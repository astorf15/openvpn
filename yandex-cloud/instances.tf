# yc compute instance
resource "yandex_compute_instance" "k8s-m" {
  count                     = 1
  zone                      = "ru-central1-a"
  name                      = "vpn-${count.index + 1}"
  hostname                  = "vpn-${count.index + 1}"
  platform_id               = "standard-v1"
  allow_stopping_for_update = true
  # lifecycle {
  # ignore_changes = all
  #}
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_22
      name     = "vpn-${count.index + 1}"
      type     = "network-ssd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = true
    ip_address = "10.2.2.1${count.index + 1}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/fozzy.pub")}"
  }
}

