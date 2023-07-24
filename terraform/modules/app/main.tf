terraform {
  required_version = ">= 0.13.1"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.35"
    }
  }
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
    # subnet_id = yandex_vpc_subnet.app-subnet.id
    subnet_id = var.subnet_id
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

# resource "yandex_compute_instance" "app" {
#   count = var.app_count

#   # Configuration for each instance
#   name = "reddit-app-${count.index}"

#   resources {
#     cores  = 2
#     memory = 2
#   }

#   boot_disk {
#     initialize_params {
#       # Specify the image ID created in the previous homework assignment
#       image_id = var.image_id
#     }
#   }

#   # network_interface {
#   #   # Specify the ID of the default-ru-central1-a subnet
#   #   subnet_id = var.subnet_id
#   #   nat       = true
#   # }
#   network_interface {
#     subnet_id = yandex_vpc_subnet.app-subnet.id
#     nat = true
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${file(var.public_key_path)}"
#   }

#   connection {
#     type        = "ssh"
#     host        = self.network_interface[0].nat_ip_address
#     user        = "ubuntu"
#     agent       = false
#     private_key = file(var.private_key_path)
#   }

#   provisioner "file" {
#     source      = "files/puma.service"
#     destination = "/tmp/puma.service"
#   }

#   provisioner "file" {
#     source      = "files/deploy.sh"
#     destination = "/tmp/deploy.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo chown ubuntu:ubuntu /tmp/puma.service",
#       "sudo chown ubuntu:ubuntu /tmp/deploy.sh",
#       "sudo chmod +x /tmp/deploy.sh"
#     ]
#   }

#   provisioner "remote-exec" {
#     script = "files/deploy.sh"
#   }
# }
