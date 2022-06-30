data docker_image nwdb {
  name = var.nw_images.nwdb.image_name
}

data docker_image nwapp {
  name = var.nw_images.nwapp.image_name
}

resource docker_network mynet {
  name = "mynet"
}

resource docker_volume myvolume {
  name = "myvolume"
}

resource docker_container nwdb_container {
  name = "nwdb"
  image = data.docker_image.nwdb.id
  networks_advanced {
    name = docker_network.mynet.name
  }
  volumes {
    volume_name = docker_volume.myvolume.name
    container_path = "/var/lib/mysql"
  }
  ports {
    internal = var.nw_images.nwdb.port
    external = var.nw_images.nwdb.port
  }
}

resource docker_container nwapp_container {
  name = "nwapp"
  image = data.docker_image.nwapp.id
  networks_advanced {
    name = docker_network.mynet.name
  }
  env = [
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_HOST=${docker_container.nwdb_container.name}",
    "PORT=3000"
  ]
  ports {
    internal = var.nw_images.nwapp.port
    external = var.nw_images.nwapp.port
  }
}