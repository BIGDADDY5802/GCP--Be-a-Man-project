# Create VPC network
resource "google_compute_network" "be_a_man_vpc" {
  name                    = "be-a-man-vpc"
  auto_create_subnetworks = false
}

# Create subnet
resource "google_compute_subnetwork" "be_a_man_subnet" {
  name          = "be-a-man-subnet"
  ip_cidr_range = "10.50.17.0/24"
  region        = "us-central1"
  network       = google_compute_network.be_a_man_vpc.id
}

# Create firewall
resource "google_compute_firewall" "allow_ssh_http" {
  name      = "allow-ssh-http"
  network   = google_compute_network.be_a_man_vpc.id
  direction = "INGRESS"
  priority  = 1000
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "icmp"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-http-server"]
}
