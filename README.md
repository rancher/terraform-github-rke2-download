# Terraform RKE2 Download

WARNING! this module is experimental

This module downloads the proper files from the RKE2 release specified and names them appropriately for the install script.

## Usage

```hcl
module "download_latest" {
  source  = "rancher/rke2-download/github"
  version = "v0.0.2"
  release = "latest"
}
```

## Requirements

| Name                              | Version         |
| --------------------------------- | --------------- |
| [terraform](#requirement\_terraform) | >= 1.1.0, < 1.6 |
| [github](#requirement\_github)       | >= 5.32.0       |
| [local](#requirement\_local)         | >= 2.4.0        |
| [null](#requirement\_null)           | >= 3.2.0        |

## Providers

| Name                     | Version   |
| ------------------------ | --------- |
| [github](#provider\_github) | >= 5.32.0 |
| [local](#provider\_local)   | >= 2.4.0  |
| [null](#provider\_null)     | >= 3.2.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                 | Type        |
| -------------------------------------------------------------------------------------------------------------------- | ----------- |
| [local_file.download_dir](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file)           | resource    |
| [null_resource.download](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)         | resource    |
| [github_release.latest](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/release)   | data source |
| [github_release.selected](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/release) | data source |
vscode-file://vscode-app/Applications/Visual%2520Studio%2520Code.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench/workbench.html
## Inputs

|              Name              | Description                                                                                                                                                                                                                                                                                                                                                                     | Type       | Default      | Required |
| :-----------------------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------- | ------------ | :------: |
|        [arch](#input\_arch)        | The architecture of the system to download for.`<br>`Valid values are amd64 (for any x86\_64), arm64, or s390x.                                                                                                                                                                                                                                                               | `string` | `"amd64"`  |    no    |
|          [os](#input\_os)          | The OS to download RPMs for.`<br>`This is only used for RPM downloads.`<br>`This is ignored when rpm is false.                                                                                                                                                                                                                                                              | `string` | `"rhel"`   |    no    |
| [os\_version](#input\_os\_version) | The version of RHEL to download RPMs for.`<br>`This is only used for RPM downloads.`<br>`This is ignored when rpm is false.                                                                                                                                                                                                                                                 | `string` | `"8"`      |    no    |
|        [path](#input\_path)        | The path to download the files to.`<br>`If not specified, the files will be downloaded to a directory named "rke2" in the root of the module.                                                                                                                                                                                                                                 | `string` | `"./rke2"` |    no    |
|     [release](#input\_release)     | The value of the git tag associated with the release to find.`<br>`Specify "latest" to find the latest release (default).`<br>`When downloading RPMs, this must be a specific release, not "latest".                                                                                                                                                                        | `string` | `"latest"` |    no    |
|         [rpm](#input\_rpm)         | Whether or not to download the RPMs.`<br>`Defaults to false.`<br>`This option requires that the system is linux (specifically RHEL based) and the architecture is amd64(x86\_64).`<br>`This option requires the computer running terraform to have curl installed.`<br>`When using this option, the "release" variable must be set to a specific release, not "latest". | `bool`   | `false`    |    no    |
|      [system](#input\_system)      | The kernel of the system to download for.`<br>`Valid values are currently just linux (the default).                                                                                                                                                                                                                                                                           | `string` | `"linux"`  |    no    |

## Outputs

| Name                   | Description                                              |
| ---------------------- | -------------------------------------------------------- |
| [assets](#output\_assets) | A list of the assets found in the GitHub release object. |
| [files](#output\_files)   | A list of the files to download.                         |
| [path](#output\_path)     | The path where the files were downloaded to.             |
| [tag](#output\_tag)       | The tag of the release that was found.                   |

## Curl and Local Filesystem Write Access

This module downloads files to your local filesystem (not a remote machine) using Curl.
This means you will need write (and read) access to your local filesystem and you will need Curl installed.
You will generally need 2GB of storage space available.
You will also need to have a GitHub token, see [GitHub Access](#github-access) below.

## GitHub Access

The GitHub provider [provides multiple ways to authenticate](https://registry.terraform.io/providers/integrations/github/latest/docs#authentication) with GitHub.
For simplicity we use the `GITHUB_TOKEN` environment variable when testing.

## Examples

### Local State

The specific use case for the example modules is temporary infrastructure for testing purposes.
With that in mind, it is not expected that we manage the resources as a team, therefore the state files are all stored locally.
If you would like to store your state files remotely, add a terraform backend file (`*.name.tfbackend`) to your implementation module.
https://www.terraform.io/language/settings/backends/configuration#file

## Development and Testing

### Paradigms and Expectations

Please make sure to read [terraform.md](./terraform.md) to understand the paradigms and expectations that this module has for development.

### Environment

It is important to us that all collaborators have the ability to develop in similar environments, so we use tools which enable this as much as possible.
These tools are not necessary, but they can make it much simpler to collaborate.

* I use [nix](https://nixos.org/) that I have installed using [their recommended script](https://nixos.org/download.html#nix-install-macos)
* I use [direnv](https://direnv.net/) that I have installed using brew.
* I simply use `direnv allow` to enter the environment
* I navigate to the `tests` directory and run `go test -v -timeout=5m -parallel=10`
* To run an individual test I navigate to the `tests` directory and run `go test -v -timeout=5m -run <test function name>`
  * eg. `go test -v -timeout=5m -run TestBasic`
* I use `override.tf` files to change the values of `examples` to personalized data so that I can run them.
* I store my GitHub credentials in a local file and generate a symlink to them named `~/.config/github/default/rc`
  * this will be automatically sourced when you enter the nix environment (and unloaded when you leave)

Our continuous integration tests in the GitHub [ubuntu-latest runner](https://github.com/actions/runner-images/blob/main/images/linux/Ubuntu2204-Readme.md), which has many different things installed
