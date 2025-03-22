terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.25.0"
    }
  }
}

provider "google" {
  # Configuration options
  project     = "gcp-project-dev-452600"
  region      = "us-central1"
  zone        = "us-central1-a"
  credentials = "gcp-project-dev-452600-8c933e673ad2.json"
}
