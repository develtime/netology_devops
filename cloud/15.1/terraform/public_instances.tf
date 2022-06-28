resource "yandex_compute_instance" "public-nat" {
  name        = "public-nat"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.network-subnet-public.id
    ip_address = "192.168.10.254"
    nat        = true
  }

  metadata = {
    user-data = "${file("/home/develtime/yc-meta.yml")}"
  }
}

resource "yandex_compute_instance" "public-vm" {
  name        = "public-vm"
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
    subnet_id = yandex_vpc_subnet.network-subnet-public.id
    nat       = true
  }

  metadata = {
    user-data = "${file("~/yc-meta.yml")}"
  }
}