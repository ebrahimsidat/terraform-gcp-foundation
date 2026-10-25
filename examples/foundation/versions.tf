terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
  }

  # Store state remotely with locking. Create the bucket once, then uncomment:
  # backend "gcs" {
  #   bucket = "example-tfstate-bucket"
  #   prefix = "foundation"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
