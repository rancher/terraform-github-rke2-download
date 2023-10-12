locals {
  version = var.release
  path    = var.path
}
module "download_rpm" {
  source  = "../../"
  release = local.version
  path    = local.path
  rpm     = true
  # default: os         = "rhel"
  # default: os_version = "8"
  # default: arch       = "amd64"
}
