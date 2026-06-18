terraform {
  required_version = ">= 1.5.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.32"
    }
    file = {
      source  = "rancher/file"
      version = ">= 1.5.0"
    }
  }
}
