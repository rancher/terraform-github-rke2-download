output "assets" {
  value       = local.assets
  description = <<-EOT
    A list of the assets found in the GitHub release object.
  EOT
}
output "files" {
  value       = local.files
  description = <<-EOT
    A list of the files to download.
  EOT
}
output "tag" {
  value       = (local.latest ? data.github_release.latest.release_tag : data.github_release.selected[0].release_tag)
  description = <<-EOT
    The tag of the release that was found.
  EOT
}
output "path" {
  value       = local.path
  description = <<-EOT
    The path where the files were downloaded to.
  EOT
}