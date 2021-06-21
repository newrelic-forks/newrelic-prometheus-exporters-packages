[![Community Plus header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Community_Plus.png)](https://opensource.newrelic.com/oss-category/#community-plus)

# Prometheus Exporter Packages

This project packages several Prometheus exporters as native operating system packages, with the goal of providing a better installation experience for Prometheus exporters.

All native packages are available for installation in New Relic's public repositories.

## Installation

To use the packages generated by this project you need to:

- Determine your OS version.
  - Debian, Red Hat, CentOS, Amazon Linux:

    ```bash
    cat /etc/os-release
    ```

  - Ubuntu

    ```bash
    cat /etc/lsb-release
    ```

  - SuSE Linux Enterprise Server

    ```bash
    cat /etc/os-release | grep VERSION_ID
    ```

- Enable New Relic's GPG key (APT and YUM packages).
  
```bash
    curl -s https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | sudo apt-key add -
```

- Add the New Relic's repository to the operating system package manager.
  - Debian based:

    ```bash
    printf "deb [arch=amd64] https://download.newrelic.com/infrastructure_agent/linux/apt <VERSION> main" | sudo tee -a /etc/apt/sources.list.d/newrelic-infra.list
    ```

    Note: replace \<VERSION> with either **jessie**, **stretch** or **buster**, depending on your Debian version

  - YUM based (Amazon Linux, Amazon Linux 2, RHEL, CentOS):

    ```bash
    sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/<VERSION>/x86_64/newrelic-infra.repo
    ```

     Note:
    - for Amazon Linux replace \<VERSION> with **6** and for Amazon Linux 2 replace with **7**
    - for CentOS and RHEL, replace \<VERSION> with the version you are using, (**5**, **6**, **7** or **8**)

- Refresh the repositories.
  - Debian, Ubuntu

    ```bash
    sudo apt-get update
    ```

  - Amazon Linux, Amazon Linux 2, RHEL, CentOS

    ```bash
    sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
    ```
  
  - SLES

    ```bash
    sudo zypper -n ref -r newrelic-infra
    ```

## Getting Started

Before installing any of the exporters, be sure to read the documentation for the specific exporter you want to install.
Each exporter may have specific configuration options that will require you to modify to make it work for your environment.

Also make sure you read the documentation about the [Infrastructure agent](https://github.com/newrelic/infrastructure-agent). The agent, in conjunction with our [Prometheus Open Metrics integration](https://github.com/newrelic/nri-prometheus), is the component responsible for sending the metrics, provided by the exporter, to New Relic.

If you followed the instructions in the [installation section](#installation) you can now install the exporter using a single command.

- Ubuntu, Debian

```bash
sudo apt-get install <exporter package name>
```

- Amazon Linux, Amazon Linux 2, RHEL, CentOS

```bash
sudo yum install <exporter package name>
```

- SLES

```bash
sudo zypper install <exporter package name>
```

## Adding a new exporter

In order to add a new exporter a new folder in the path `exporters/{exportername}` should be created. You can refer to `githubactions` exporter example in order to doublecheck parameters and fields of scripts and definitions

In each folder we expect to find:
  - `exporter.yml`: definition of the exporter
  - `build.sh` a bash script that will generate the exporter binary under `exporters/{exportername}/target/bin/`
  - `{exporterName}-config.yml.sample` containing the configuration sample for the Infrastructure Agent to run the exporter
  - `{exporterName}.json.tmpl` containing the configuration mappings

The definition file requieres the following fields:
``` yaml
# name of the exporter, should mach with the folder name
name: githubactions
# version of the package created
version: 1.2.2
# URL to the git project hosting the exporter
exporter_repo_url: https://github.com/Spendesk/github-actions-exporter
# Tag of the exporter to checkout
exporter_tag: v1.2
# Commit of the exporter to checkout (used if tag property is empty)
exporter_commit: ifTagIsSetThisIsNotUsed
# Changelog to add to the new release
exporter_changelog: "Changelog for the current version, nothing relly changed, just testing pipeline"
# Enable packages for Linux
package_linux: true
# Enable packages for Windows
package_windows: true
# Upgrade GUID used in the msi package. Required if package_windows is set to true
# This GUID should be generated and be unique across all exporters in the repository
upgrade_guid: 58F31C6C-DB0A-455E-9E4C-5C9AD4A8932B
# Exporter GUID used in the msi package Required if package_windows is set to true
# This GUID should be generated and be unique across all exporters in the repository
exporter_guid: 7B629E90-530F-4FAA-B7FE-1F1B30A95714
# Lincense GUID used in the msi package Required if package_windows is set to true
# This GUID should be generated and be unique across all exporters in the repository
nri_guid: 81068A97-AC58-47DD-90DF-2DEAC18C0E17
# Exporter GUID used in the msi package. Required if package_windows is set to true
# This GUID should be generated and be unique across all exporters in the repository
license_guid: 95E897AC-895A-43BE-A5EF-D72AD58E4ED1
# Config GUID used in the msi package Required if package_windows is set to true
# This GUID should be generated and be unique across all exporters in the repository
config_guid: 45C8D11D-57DB-4C0A-AB5E-61B6A7D3DBC0
# Definition GUID used in the msi package Required if package_windows is set to true
# This GUID should be generated and be unique across all exporters in the repository
definition_guid: 866A014A-181C-4DD2-8FD0-01521F54F1A1
```

When added open a PR and once merged to master a github action workflow will start building and uploading packages to Github. 

 - In case one exporter definition has been modified or added the exporter will be released for the os requested and a Github release will be created
 - In case more than one exporter definitions have been modified the pipeline fail.

Please notice that exporters have their own `build` script but they share the packaging scripts, located under `./scripts`

## Support

Should you need assistance with New Relic products, you are in good hands with several support diagnostic tools and support channels.



> New Relic offers NRDiag, [a client-side diagnostic utility](https://docs.newrelic.com/docs/using-new-relic/cross-product-functions/troubleshooting/new-relic-diagnostics) that automatically detects common problems with New Relic agents. If NRDiag detects a problem, it suggests troubleshooting steps. NRDiag can also automatically attach troubleshooting data to a New Relic Support ticket.

If the issue has been confirmed as a bug or is a Feature request, please file a Github issue.

**Support Channels**

* [New Relic Documentation](https://docs.newrelic.com): Comprehensive guidance for using our platform
* [New Relic Community](https://discuss.newrelic.com): The best place to engage in troubleshooting questions
* [New Relic Developer](https://developer.newrelic.com/): Resources for building a custom observability applications
* [New Relic University](https://learn.newrelic.com/): A range of online training for New Relic users of every level
* [New Relic Technical Support](https://support.newrelic.com/) 24/7/365 ticketed support. Read more about our [Technical Support Offerings](https://docs.newrelic.com/docs/licenses/license-information/general-usage-licenses/support-plan).

## Privacy

At New Relic we take your privacy and the security of your information seriously, and are committed to protecting your information. We must emphasize the importance of not sharing personal data in public forums, and ask all users to scrub logs and diagnostic information for sensitive information, whether personal, proprietary, or otherwise.

We define “Personal Data” as any information relating to an identified or identifiable individual, including, for example, your name, phone number, post code or zip code, Device ID, IP address, and email address.

For more information, review [New Relic’s General Data Privacy Notice](https://newrelic.com/termsandconditions/privacy).

## Contribute

We encourage your contributions to improve this project! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

If you would like to contribute to this project, review [these guidelines](./CONTRIBUTING.md).

To all contributors, we thank you!  Without your contribution, this project would not be what it is today.

## License
Prometheus Exporter Packages is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
