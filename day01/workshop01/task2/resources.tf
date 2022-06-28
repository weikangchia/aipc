data "digitalocean_ssh_key" "fred" {
  name = "fred"
}

resource digitalocean_droplet nginx {
  name = "nginx"
  image = var.DO_image
  size = var.DO_size
  region = var.DO_region
  ssh_keys = [data.digitalocean_ssh_key.fred.id]
  connection {
    type = "ssh"
    user = "root"
    private_key = file(var.DO_private_key)
    host = self.ipv4_address
  }
  provisioner remote-exec {
    inline = [
      "apt update",
      "apt install nginx -y",
      "systemctl enable nginx",
      "systemctl start nginx"
    ]
  }
}

output nginx_ip {
  value = digitalocean_droplet.nginx.ipv4_address
}

resource local_file root_at_nginx {
  content = ""
  filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
}