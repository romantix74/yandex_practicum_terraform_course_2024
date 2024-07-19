locals {
    zone = "ru-central1-b"
}

resource "yandex_vpc_network" "dev" {
  name = "test-vpc"
}

resource "yandex_vpc_subnet" "dev" {
  name           = "test-subnet"
  zone           = local.zone
  network_id     = yandex_vpc_network.dev.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}

data "yandex_compute_image" "dev" {
  family = "container-optimized-image"
}

resource "yandex_compute_disk" "testvm" {
  name     = "test-vm-disk"
  zone     = local.zone
  image_id = data.yandex_compute_image.dev.image_id
  size     = "15"

  lifecycle {
    ignore_changes = [image_id]
  }
}


import {
  to = yandex_compute_instance.testvm
  id = "epdrfscm4d7qgog4jrip"
}

resource "yandex_compute_instance" "testvm" {
  name                      = "testvm"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }
          
  scheduling_policy {
    preemptible = true
  }
  
  boot_disk {
    disk_id = yandex_compute_disk.testvm.id
    auto_delete = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.dev.id
  }
}
