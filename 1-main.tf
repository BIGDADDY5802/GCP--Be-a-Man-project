# Create storage bucket
resource "google_storage_bucket" "be-a-man-cloud-computing" {
  name          = "be_a_man_rob_and_theo_extra_credit_i_am_certified"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# Uncomment if you want to create a service account
# resource "google_service_account" "default" {
#   account_id   = "my-custom-sa"
#   display_name = "Custom SA for VM Instance"
# }

# Create VM instance
resource "google_compute_instance" "be-a-man-vm" {
  name         = "be-a-man-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  tags         = ["be-a-man-extra-credit", "gcpcertification"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }


  network_interface {
    network    = google_compute_network.be_a_man_vpc.id
    subnetwork = google_compute_subnetwork.be_a_man_subnet.id
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
