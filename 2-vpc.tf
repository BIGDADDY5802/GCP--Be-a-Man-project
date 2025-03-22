# Create VPC network
resource "google_compute_network" "be_a_man_vpc" {
  name                    = "be-a-man-vpc"
  auto_create_subnetworks = false
}

# Create subnet
resource "google_compute_subnetwork" "be_a_man_subnet" {
  name          = "be-a-man-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.be_a_man_vpc.id
}
