locals {
  system       = var.system
  arch         = var.arch
  release      = var.release
  latest       = (var.release == "latest" ? true : false)
  latest_url   = "https://raw.githubusercontent.com/rancher/rke2/master/install.sh"
  release_url  = "https://raw.githubusercontent.com/rancher/rke2/refs/tags/${urlencode(local.release)}/install.sh"
  install_url  = local.latest ? local.latest_url : local.release_url
  path         = var.path
  default_path = (local.path == "./rke2" ? true : false)

  selected_assets = (can(data.github_release.selected[0].assets) ? { for a in data.github_release.selected[0].assets : a.name => a.browser_download_url } : {})
  latest_assets   = (can(data.github_release.latest.assets) ? { for a in data.github_release.latest.assets : a.name => a.browser_download_url } : {})
  assets          = (local.latest ? local.latest_assets : local.selected_assets)

  files = {
    "rke2-images.${local.system}-${local.arch}.tar.gz" = local.assets["rke2-images.${local.system}-${local.arch}.tar.gz"],
    "rke2.${local.system}-${local.arch}.tar.gz"        = local.assets["rke2.${local.system}-${local.arch}.tar.gz"],
    "sha256sum-${local.arch}.txt"                      = local.assets["sha256sum-${local.arch}.txt"],
    "install.sh"                                       = local.install_url,
  }
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

# create a directory to download the files to if using the default ./rke2 path
resource "file_local_directory" "download_dir" {
  count       = local.default_path ? 1 : 0
  path        = local.path
  permissions = "0755"
}

resource "file_local" "download_dir_readme" {
  depends_on = [
    data.github_release.latest,
    data.github_release.selected,
    file_local_directory.download_dir,
  ]
  directory   = local.path
  name        = "README.md"
  contents    = <<-EOT
    # RKE2 Downloads
    This directory is used to download the RKE2 installer and images.
  EOT
  permissions = "0644"
}

# requires curl to be installed in the environment running terraform
resource "terraform_data" "download" {
  depends_on = [
    data.github_release.selected,
    data.github_release.latest,
    file_local.download_dir_readme,
  ]
  for_each         = local.files
  triggers_replace = each.value
  provisioner "local-exec" {
    command = <<-EOT
      # we are only downloading here and the checksum is downloaded as well
      curl --clobber -L -s -o "${local.path}/${each.key}" "${each.value}"
    EOT
  }
}
