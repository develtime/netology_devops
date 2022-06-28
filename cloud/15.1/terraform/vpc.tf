resource "yandex_vpc_network" "netology-network" {
  name = "netology-network"
}

resource "yandex_vpc_route_table" "route-private-to-public" {
  name       = "private-to-public"
  network_id = yandex_vpc_network.netology-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

resource "yandex_vpc_subnet" "network-subnet-public" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  name           = "public"
  network_id     = yandex_vpc_network.netology-network.id
}

resource "yandex_vpc_subnet" "network-subnet-private" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  name           = "private"
  network_id     = yandex_vpc_network.netology-network.id
  route_table_id = yandex_vpc_route_table.route-private-to-public.id
}