locals {
  system      = var.system
  arch        = var.arch
  release     = var.release
  latest      = (var.release == "latest" ? true : false)
  install_url = "https://raw.githubusercontent.com/rancher/rke2/master/install.sh"
  path        = abspath(var.path)

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
resource "terraform_data" "download" {
  depends_on = [
    data.github_release.selected,
    data.github_release.latest,
    local_file.download_dir,
  ]
  for_each         = local.files
  triggers_replace = each.value
  provisioner "local-exec" {
    command = <<-EOT
      curl --clobber -L -s -o ${"${local.path}/${each.key}"} ${each.value}
    EOT
  }
}
