variable DO_token {
  type = string
  sensitive = true
}

variable DO_image {
  type = string
  default = "ubuntu-20-04-x64"
}

variable DO_region {
  type = string
  default = "sgp1"
}

variable DO_size {
  type = string
  default = "s-1vpcu-1gb"
}

variable DO_private_key {
  type = string
  sensitive = true
}

variable containers {
  // type definition
  type = map(object({
    external_port = number
  }))

  default = {
    "1" = {
      external_port = 8080
    }
    "2" = {
      external_port = 8081
    }
    "3" = {
      external_port = 8082
    }
  }
}

variable docker_host {
  type = string
  default = "128.199.179.87"
}