resource "yandex_compute_instance" "vpn" {
  name                      = "vpn"
  zone                      = "ru-central1-a"
  hostname                  = "vpn"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }
  
  boot_disk {
    initialize_params {
      image_id = var.ubuntu_20
      name     = "disk-vpn"
      type     = "network-nvme"
      size     = "50"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet.id
    nat        = true
    ip_address = "10.2.2.10"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
