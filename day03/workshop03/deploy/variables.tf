variable DO_token {
  type = string
  sensitive = true
}

variable DO_image {
  type = string
  default = "codeserver"
}

variable DO_region {
  type = string
  default = "sgp1"
}

variable DO_size {
  type = string
  default = "s-1vcpu-2gb"
}

variable DO_private_key {
  type = string
  sensitive = true
}

variable codeserver_password {
  type = string
  sensitive = true
}

variable codeserver_version {
  type = string
  default = "3.3.1"
}