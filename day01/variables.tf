variable DO_token {
  type = string
  sensitive = true
}

variable ports {
  type = list(number)
  default = [8080, 8081, 8082, 8083]
}

variable containers {
  // type definition
  type = map(object({
    external_port = number
  }))

  default = {
    abc = {
      external_port = 8080
    }
    xyz = {
      external_port = 8081
    }
  }
}