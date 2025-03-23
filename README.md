# Terraform GCP build
0. you must have a VS Code (visual studio code)

1. create a GCP account everything is in the preinstallation documentation (assuming everyone created an account)
- create a service account and add the service roles. This is very important to add on the IAM.

-Roles to add 
- Compute Admin 
- Compute instance 
- Storage Admin
- Service Account User

2. build the Provider first
 
- create a folder within the local file or type `mkdir <folder_name.extension>`
- create a file within your local file or use your cli (only for windows) type `notepad <file_name.extension>` (for mac) type `touch <file_name.extension>`
- make sure you cd into the file `cd <folder_name>`
- go to the hashicorp registry and go to the gcp provider
- add a provider ![[Pasted image 20250323103045.png]]
- make sure you adjust the version because 6.26.0 may not work i tested it and i had an error so drop it to 6.25.0
- add your configuration options
```provider "google" {

  # Configuration options

  project     = "---project I.D.-----"

  region      = "----region----"

  zone        = "---zone---"

  credentials = "-----json credentials-----"

}
```

- terraform init
- terraform fmt (formating is important)
- terraform validate
- terraform plan
- terraform apply
-it should work
- No need to destroy because no resources was deployed

3. build a main.tf
- create a main.tf 
- create a storage bucket (optional) for best practices usage
-![[Pasted image 20250323110244.png]]
- create a VM
-![[Screenshot 2025-03-23 110338.png]]
Example:
```
# Create storage bucket

resource "google_storage_bucket" "be-a-man-cloud-computing" {

  name          = "be_a_man_rob_and_theo_extra_credit_i_am_certified"

  location      = "US"

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

#   account_id   = "my-custom-sa"

#   display_name = "Custom SA for VM Instance"

# }

  

# Create VM instance

resource "google_compute_instance" "be-a-man-vm" {

  name         = "be-a-man-vm"

  machine_type = "e2-medium"

  zone         = "us-central1-a"

  tags         = ["ssh-http-server"]

  

  boot_disk {

    initialize_params {

      image = "debian-cloud/debian-11"

      labels = {

        my_label = "value"

      }

    }

  }

  
  

  network_interface {

    network    = google_compute_network.be_a_man_vpc.id

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
```

-make the necessary edits of your infrastructure and then go test it out through the initialization, plan, and apply and if it works congratulations of deploying your vm once done make sure you destroy the vm Because you will be charged!!!!

4. build VPC network
- create a VPC file 
-![[Pasted image 20250323111638.png]]
- take copy and paste or type up the code and make the necessary edits

- add a subnet
-![[Pasted image 20250323112138.png]]
- make the necessary edits like always the resource name name it how ever you want it. 
- type up your ip cidr range of your own
- region
- most important network argument change the custom-test.id and make sure it matches your vpc network name and keep the .id otherwise it will not recognize or won't think it exists

- create a firewall (it's very important)
-![[Pasted image 20250323112927.png]]
- make the necessary edits like the previous build
- make sure you allow icmp, tcp, and the necessary ports (22 and 80) for ssh and http purposes
- you need the log_config to have the log on
- Have source ranges to specified the fire wall to apply traffic
- have the priority at 1000 (default) you could have it at 100 but the GCP master class udemy will explain further https://www.udemy.com/share/1037k43@H0edWgSMSvkQlZKVcX_fX2jkXNxC7oXWSy92suRHni70ND9F6GWYVj7oNiVv9hu-Vg==/
-in section 10 70. Routes in vpc because the highest priority is the lowest priority number and the lower numbers indicate higher priorities

- add your document user data script on the metadata

- oh and very important have tags for your vm and target tags for your networks
- attach your vpc network and subnet to the vm so it can connect

Example:
```
# Create VPC network

resource "google_compute_network" "be_a_man_vpc" {

  name                    = "be-a-man-vpc"

  auto_create_subnetworks = false

}

  

# Create subnet

resource "google_compute_subnetwork" "be_a_man_subnet" {

  name          = "be-a-man-subnet"

  ip_cidr_range = "10.50.17.0/24"

  region        = "us-central1"

  network       = google_compute_network.be_a_man_vpc.id

}

  

# Create firewall

resource "google_compute_firewall" "allow_ssh_http" {

  name      = "allow-ssh-http"

  network   = google_compute_network.be_a_man_vpc.id

  direction = "INGRESS"

  priority  = 1000

  allow {

    protocol = "tcp"

    ports    = ["22"]

  }

  

  allow {

    protocol = "tcp"

    ports    = ["80"]

  }

  

  allow {

    protocol = "icmp"

  }

  

  log_config {

    metadata = "INCLUDE_ALL_METADATA"

  }

  source_ranges = ["0.0.0.0/0"]

  target_tags   = ["ssh-http-server"]

}
```


- format is very important and make sure your references is proper
- type up the terraform process and test it out
- if it works congratulation
- go to your GCP console connect to your SSH and you start typing your sudo commands to connect your external ip 
-Step-by-Step Commands in SSH:

#### 1. **Update and Install Apache** (if not already done)

bash

CopyEdit

`sudo apt update sudo apt install -y apache2`

#### 2. **Start Apache and enable it to auto-start**

bash

CopyEdit

`sudo systemctl start apache2 sudo systemctl enable apache2`

#### 3. **Remove the default Apache index file**
(if you applied a Apache index file in your metadata user script if you didn't then don't worry about it)

bash

CopyEdit

`sudo rm /var/www/html/index.html`

#### 4. **Create a new custom `index.html` file**

You can use `nano` or `vim` to create the file manually:

bash

CopyEdit

`sudo nano /var/www/html/index.html`

then type your web server http://<external ip> and then it should work
