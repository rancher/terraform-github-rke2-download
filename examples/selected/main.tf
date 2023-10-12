locals {
  version = var.release
  path    = var.path
}
module "download_selected" {
  source  = "../../"
  release = local.version
  path    = local.path
}
