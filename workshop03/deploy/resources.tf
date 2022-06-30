data "digitalocean_ssh_key" "fred" {
  name = "fred"
}

data digitalocean_image codeserver {
  name = "${var.DO_image}:${var.codeserver_version}"
}

resource digitalocean_droplet codeserver {
  name = "codeserver"
  image = data.digitalocean_image.codeserver.id
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

locals {
  codeserver_domain = "code-${digitalocean_droplet.codeserver.ipv4_address}.nip.io"
}

output codeserver_ip {
  value = digitalocean_droplet.codeserver.ipv4_address
}

output codeserver_domain {
  value = local.codeserver_domain
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
    codeserver_domain = local.codeserver_domain
  })
  filename = "inventory.yaml"
  file_permission = "0644"
}