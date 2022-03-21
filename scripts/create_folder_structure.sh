#!/bin/bash
root_dir=$1
integration=$2
integration_dir="${root_dir}/exporters/${integration}"

target_dir="${integration_dir}/target"
binaries_dir="${target_dir}/bin"
source_dir="${target_dir}/source"

integrations_exec_dir="${source_dir}/var/db/newrelic-infra/newrelic-integrations/bin/"
exporters_exec_dir="${source_dir}/usr/local/prometheus-exporters/bin/"
integrations_config_dir="${source_dir}/etc/newrelic-infra/integrations.d"
exporters_doc_dir="${source_dir}/usr/local/share/doc/prometheus-exporters"

create_folders_structure() {
  rm -rf "${source_dir}"
	mkdir -p "${exporters_exec_dir}" \
	  "${integrations_exec_dir}" \
	  "${integrations_config_dir}" \
	  "${exporters_doc_dir}"
}


create_folders_structure