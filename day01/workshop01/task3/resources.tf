// terraform uses underscore, so we can't use underscore
// <provider_name>_ssh_key
data "digitalocean_ssh_key" "aipc" {
  name = "aipc"
}

data docker_image dovbear {
  name = "chukmunnlee/dov-bear:v1"
}

// option 2
resource docker_container dovbear_container {
  for_each = var.containers
  name = "dov-${each.key}"
  image = data.docker_image.dovbear.id
  env = [
    "INSTANCE_NAME=dov",
    "INSTANCE_HASH=${each.key}"
  ]
  ports {
    internal = 3000
    external = each.value.external_port
  }
}

resource local_file nginx_conf {
  content = templatefile("nginx.conf.tpl", {
    docker_ports = [for c in var.containers: c.external_port],
    docker_ip = var.docker_host
  })
  filename = "nginx.conf"
}

data "digitalocean_ssh_key" "fred" {
  name = "fred"
}

resource digitalocean_droplet nginx {
  depends_on = [
    resource.local_file.nginx_conf
  ]
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
  provisioner file {
    source = "./nginx.conf"
    destination = "/etc/nginx/nginx.conf"
  }
  provisioner remote-exec {
    inline = [
      "/usr/sbin/nginx -s reload"
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