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
  tags         = ["ssh-http-server"]

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

  metadata_startup_script = <<-EOT
  #!/bin/bash
  apt update
  apt install -y apache2
  systemctl enable apache2
  systemctl start apache2

  cat <<EOF > /index.html
  <!DOCTYPE html>
  <html>
  <head>
    <title>My Terraform Deployed GCP Page</title>
    <style>
      body { font-family: Arial, sans-serif; background-color: #f5f5f5; text-align: center; padding: 40px; }
      h1 { color: #333; }
      img { margin: 20px auto; max-width: 400px; display: block; }
    </style>
  </head>
  <body>
    <h1>🌐 Welcome to My GCP VM and be a man! 🚀</h1>
    <p>This page was created with Terraform and deployed on a Google Cloud VM.</p>

    <h2>Here’s a Static Image:</h2>
    <img src="https://preview.redd.it/dg1yx4559d061.jpg?width=640&crop=smart&auto=webp&s=8fd0b0e0f2b62bd55785684e904c99b0ddb2e027" alt="Earth from Space">

    <h2>And Here’s a Fun GIF:</h2>
    <img src="https://www.icegif.com/wp-content/uploads/2022/09/icegif-182.gif" alt="Dancing">

  </body>
  </html>
  EOF
EOT



  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
