variable "release" {
  type        = string
  description = <<-EOT
    The value of the git tag associated with the release to find.
    Specify "latest" to find the latest release (default).
  EOT
  default     = "latest"
}
variable "arch" {
  type        = string
  description = <<-EOT
    The architecture of the system to download for.
    Valid values are amd64 (for any x86_64), arm64, or s390x.
  EOT
  default     = "amd64"
}
variable "system" {
  type        = string
  description = <<-EOT
    The kernel of the system to download for.
    Valid values are currently just linux (the default).
  EOT
  default     = "linux"
}
variable "path" {
  type        = string
  description = <<-EOT
    The path to download the files to.
    If not specified, the files will be downloaded to a directory named "rke2" in the root module.
  EOT
  default     = "./rke2"
}
