locals {
  system          = var.system
  rpm             = var.rpm
  release         = var.release
  latest          = (var.release == "latest" ? true : false)
  sem             = (local.latest ? [] : regex("v([0-9]+)\\.([0-9]+)\\.([0-9]+)", var.release)) # extracts the semver from the release string
  kube            = (local.latest ? "" : "${local.sem[0]}.${local.sem[1]}")                     # build the major.minor version of kubernetes
  arch            = var.arch
  os              = (local.rpm ? var.os : "")         # should be rhel, but should only be used when downloading RPMs
  os_version      = (local.rpm ? var.os_version : "") # should only be used when downloading RPMs
  install_url     = "https://raw.githubusercontent.com/rancher/rke2/master/install.sh"
  rpm_os          = (local.os == "rhel" ? "centos" : local.os)
  rpm_arch        = (local.arch == "amd64" ? "x86_64" : local.arch)
  rpm_url         = "https://rpm.rancher.io/rke2/stable/${local.kube}/${local.rpm_os}/${local.os_version}"
  rpm_release     = (local.latest ? "" : "${local.sem[0]}.${local.sem[1]}.${local.sem[2]}~rke2r1-0.el${local.os_version}.${local.arch}")
  selected_assets = (can(data.github_release.selected[0].assets) ? { for a in data.github_release.selected[0].assets : a.name => a.browser_download_url } : {})
  latest_assets   = (can(data.github_release.latest.assets) ? { for a in data.github_release.latest.assets : a.name => a.browser_download_url } : {})
  assets          = (local.latest ? local.latest_assets : local.selected_assets)
  base_files = {
    "rke2-images.${local.system}-${local.arch}.tar.gz" = local.assets["rke2-images.${local.system}-${local.arch}.tar.gz"],
    "rke2.${local.system}-${local.arch}.tar.gz"        = local.assets["rke2.${local.system}-${local.arch}.tar.gz"],
    "sha256sum-${local.arch}.txt"                      = local.assets["sha256sum-${local.arch}.txt"],
    "install.sh"                                       = local.install_url,
  }
  files = (local.rpm ? merge(local.base_files, {
    "rke2-common.rpm"  = "${local.rpm_url}/${local.rpm_arch}/rke2-common-${local.rpm_release}.rpm",
    "rke2-server.rpm"  = "${local.rpm_url}/${local.rpm_arch}/rke2-server-${local.rpm_release}.rpm",
    "rke2-agent.rpm"   = "${local.rpm_url}/${local.rpm_arch}/rke2-agent-${local.rpm_release}.rpm",
    "rke2-selinux.rpm" = "${local.rpm_url}/noarch/rke2-selinux-0.15-1.el${local.os_version}.noarch.rpm",
  }) : local.base_files)
  path = abspath(var.path)
}

data "github_release" "selected" {
  count       = (local.latest ? 0 : 1)
  repository  = "rke2"
  owner       = "rancher"
  retrieve_by = "tag"
  release_tag = local.release
}

data "github_release" "latest" {
  repository  = "rke2"
  owner       = "rancher"
  retrieve_by = "latest"
}

# create a directory to download the files to if path does not exist
resource "local_file" "download_dir" {
  depends_on = [
    data.github_release.latest,
    data.github_release.selected,
  ]
  filename             = "${local.path}/README.md"
  content              = <<-EOT
    # RKE2 Downloads
    This directory is used to download the RKE2 installer and images.
  EOT
  directory_permission = "0755"
  file_permission      = "0644"
}

# requires curl to be installed in the environment running terraform
resource "null_resource" "download" {
  depends_on = [
    data.github_release.selected,
    data.github_release.latest,
    local_file.download_dir,
  ]
  for_each = local.files
  provisioner "local-exec" {
    command = <<-EOT
      curl -L -s -o ${abspath("${local.path}/${each.key}")} ${each.value}
    EOT
  }
}
