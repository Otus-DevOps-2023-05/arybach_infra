terraform {
  required_version = ">=0.13.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">=0.93.0"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../modules/vpc/terraform.tfstate"
  }
}

# Fetch details of existing resources from Yandex Cloud
data "yandex_vpc_network" "app-network" {
  name = "reddit-app-network"
}

data "yandex_vpc_subnet" "app-subnet" {
  name = "reddit-app-subnet"
}

data "yandex_vpc_security_group" "reddit" {
  name = "reddit-sg"
}

resource "yandex_compute_instance" "app" {
  name = "reddit-app"

  labels = {
    tags = "reddit-app"
  }
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = data.terraform_remote_state.vpc.outputs.vpc_subnet_id
    nat       = true
    security_group_ids = [data.terraform_remote_state.vpc.outputs.reddit_sg_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
