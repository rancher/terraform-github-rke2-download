locals {
  version = var.release
  path    = var.path
}
module "TestSelected" {
  source  = "../../"
  release = local.version
  path    = local.path
}
