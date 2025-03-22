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
  project     = "---Project ID------"
  region      = "us-central1"
  zone        = "us-central1-a"
  credentials = "---GCP json Creditials----"
}
