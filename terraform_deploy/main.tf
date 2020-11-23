provider "google" {
  credentials = var.credentials
  project = var.project 
  region  = var.region
}

resource "google_compute_instance" "terraform" {
  name         = "terraform-testing"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {

    }
  }
  
}
