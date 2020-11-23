resource "tls_private_key" "ssh-key" {
  algorithm   = "RSA"
}

provider "google" {
  credentials = var.credentials
  project = var.project 
  region  = var.region
}

resource "google_compute_instance" "terraform" {
  name         = "monitoring-system"
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
  
  metadata = {
    ssh-keys = "${var.user}:${tls_private_key.ssh-key.public_key_openssh}"
  }
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      port        = 22
      user        = var.user
      timeout     = "300s"
      private_key = tls_private_key.ssh-key.private_key_pem
      host = google_compute_instance.terraform.network_interface.0.access_config.0.nat_ip
    }

    inline = [
      "touch temp.txt"
    ]
  }
  
}
