variable "release" {
  type        = string
  description = <<-EOT
    The value of the git tag associated with the release to find.
  EOT
}
variable "path" {
  type        = string
  description = <<-EOT
    The path to download the files to.
  EOT
}