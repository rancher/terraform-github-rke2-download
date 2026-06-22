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
    Valid values are amd64 (for any x86_64) or arm64.
  EOT
  default     = "amd64"

  validation {
    condition     = contains(["amd64", "arm64"], var.arch)
    error_message = "The arch variable must be one of 'amd64' or 'arm64'."
  }
}
variable "system" {
  type        = string
  description = <<-EOT
    The kernel of the system to download for.
    Valid values are currently just linux (the default).
  EOT
  default     = "linux"

  validation {
    condition     = var.system == "linux"
    error_message = "The system variable must be 'linux'."
  }
}
variable "path" {
  type        = string
  description = <<-EOT
    The path to download the files to.
    If specified the path must exist, otherwise the "rke2" directory will be created.
    If not specified, the files will be downloaded to a directory named "rke2" in the root module.
  EOT
  default     = "./rke2"
}
