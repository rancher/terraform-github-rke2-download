terraform {
  required_version = ">= 1.2.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.32"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
  }
}
SD