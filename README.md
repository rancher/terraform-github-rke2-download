# Terraform RKE2 Download

WARNING! this module is experimental

This module downloads the proper files from the RKE2 release specified and names them appropriately for the install script.

## File Path

The `file_path` variable informs the module where to put the files.
If left empty it will place them in a new "rke2" directory in the root module directory.

## Curl and Local Filesystem Write Access

This module downloads files to your local filesystem (not a remote machine) using Curl.
This means you will need write (and read) access to your local filesystem and you will need Curl installed.
You will generally need 2GB of storage space available.
You will also need to have a GitHub token, see [GitHub Access](#github-access) below.

## Release

This is the version of rke2 to install, even when supplying the files it is necessary to specify the exact version of rke2 you are installing.

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
