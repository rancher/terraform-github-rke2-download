variable "release" {
  type        = string
  description = <<-EOT
    The value of the git tag associated with the release to find.
    Specify "latest" to find the latest release (default).
    When downloading RPMs, this must be a specific release, not "latest".
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
variable "os" {
  type        = string
  description = <<-EOT
    The OS to download RPMs for.
    This is only used for RPM downloads.
    This is ignored when rpm is false.
  EOT
  default     = "rhel"
}
variable "os_version" {
  type        = string
  description = <<-EOT
    The version of RHEL to download RPMs for.
    This is only used for RPM downloads.
    This is ignored when rpm is false.
  EOT
  default     = "8"
}

variable "path" {
  type        = string
  description = <<-EOT
    The path to download the files to.
    If not specified, the files will be downloaded to a directory named "rke2" in the root of the module.
  EOT
  default     = "./rke2"
}
variable "rpm" {
  type        = bool
  description = <<-EOT
    Whether or not to download the RPMs.
    Defaults to false.
    This option requires that the system is linux (specifically RHEL based) and the architecture is amd64(x86_64).
    This option requires the computer running terraform to have curl installed.
    When using this option, the "release" variable must be set to a specific release, not "latest".
  EOT
  default     = false
}