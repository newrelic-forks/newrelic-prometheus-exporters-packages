#!/bin/bash
set -eo pipefail

goreleaser_bin=${GORELEASER_BIN:-goreleaser}

root_dir=$1
integration=$2
goos=$3

integration_dir="${root_dir}/exporters/${integration}"
integration_target="${integration_dir}/target"
goreleaser_file="${root_dir}/scripts/pkg/.goreleaser.yml"
goreleaser_file_template="${goreleaser_file}.template"

echo "Loading Variables of of exporter"
source "${root_dir}"/scripts/common_functions.sh
loadVariables "${integration_dir}"/exporter.yml

echo "Package configurator"

echo "Downloading the license and placing it under ${integration_target}/${integration}-LICENSE"
tmp_dir=$(mktemp -d)
filename="${EXPORTER_LICENSE_PATH}"
git clone "${EXPORTER_REPO_URL}" "${tmp_dir}"
tmp_license_file="${tmp_dir}/${filename}"
if [ ! -f "${tmp_license_file}" ]; then
  echo "Cannot find a LICENSE file called ${filename} in the exporter repo";
  exit 1;
fi
cp "${tmp_license_file}" "${integration_target}/${integration}-LICENSE"
rm -rf "${tmp_dir}"

echo "Packaging"
mkdir -pv "${integration_target}/packages"
if [ "$goos" == "windows" ]; then
    powershell.exe -file "${root_dir}/scripts/win_msi_build.ps1" -arch amd64 -exporterName ${NAME} -version ${VERSION} -exporterGUID ${EXPORTER_GUID} -upgradeGUID ${UPGRADE_GUID} -licenseGUID ${LICENSE_GUID}

    mkdir -p "${root_dir}/dist/New Relic/newrelic-infra/integrations.d"
    cp "${integration_dir}/${NAME}-config.yml.sample" "${root_dir}/dist/New Relic/newrelic-infra/integrations.d/"

    mkdir -p "${root_dir}/dist/New Relic/newrelic-infra/newrelic-integrations/bin"
    cp "${integration_target}/bin/nri-${NAME}.exe" "${root_dir}/dist/New Relic/newrelic-infra/newrelic-integrations/bin"
    cp "${integration_dir}/${NAME}-win-definition.yml" "${root_dir}/dist/New Relic/newrelic-infra/newrelic-integrations/" || true

    mkdir -p "${root_dir}/dist/New Relic/newrelic-infra/logging.d"
    cp "${integration_dir}/${NAME}-log-win.yml" "${root_dir}/dist/New Relic/newrelic-infra/logging.d/" || true

    (
      # Inside a subshell so we do not change $PWD to the rest of the script
      cd "${root_dir}/dist"
      7z a -tzip "${integration_dir}/target/packages/nri-${NAME}-amd64.${VERSION}.zip" "New Relic"
    )
else
    cp "${goreleaser_file_template}" "${goreleaser_file}"
    yq e -i ".nfpms[0].package_name = \"nri-${NAME}\"" "${goreleaser_file}"

    IFS=',' read -r -a goarchs <<< "$PACKAGE_LINUX_GOARCHS"
    for goarch in "${goarchs[@]}"
    do
      echo  "Adding ${goarch} to goreleaser"
      yq e -i ".builds[0].goarch += [ \"${goarch}\" ]" "${goreleaser_file}"
    done

    if [ "x${CI}" = "xtrue" ]; then
      git tag ${VERSION}  # Tag the repository in case we are in a CI.
      GORELEASER_CURRENT_TAG=${VERSION} ${goreleaser_bin} release --config "${goreleaser_file}" --rm-dist
    else
      GORELEASER_CURRENT_TAG=${VERSION} ${goreleaser_bin} release --config "${goreleaser_file}" --rm-dist --snapshot
    fi

    echo "Signing the packages"
    #bash ${root_dir}/scripts/sign.sh "${root_dir}" "${integration}"

    cp "${root_dir}/dist/"*.{rpm,deb,tar.gz} ${integration_target}/packages
fi
