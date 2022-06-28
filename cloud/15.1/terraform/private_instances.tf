resource "yandex_compute_instance" "private-vm" {
  name        = "private-vm"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd88d14a6790do254kj7"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.network-subnet-private.id
  }

  metadata = {
    user-data = "${file("~/yc-meta.yml")}"
  }
}