data "digitalocean_ssh_key" "fred" {
  name = "fred"
}

resource digitalocean_droplet codeserver {
  name = "codeserver"
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
}

output codeserver_ip {
  value = digitalocean_droplet.codeserver.ipv4_address
}

resource local_file root_at_codeserver {
  content = ""
  filename = "root@${digitalocean_droplet.codeserver.ipv4_address}"
  file_permission = "0644"
}

resource local_file nginx_conf {
  content = templatefile("inventory.yaml.tpl", {
    codeserver_host_ip = digitalocean_droplet.codeserver.ipv4_address,
    path_to_private_key = var.DO_private_key,
    codeserver_password = var.codeserver_password
  })
  filename = "inventory.yaml"
  file_permission = "0644"
}