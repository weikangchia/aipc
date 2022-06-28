variable nw_images {
  type = map(object({
    image_name = string
    port = number
  }))

  default = {
    nwdb = {
      image_name = "stackupiss/northwind-db:v1"
      port = 3006
    }
    nwapp = {
      image_name = "stackupiss/northwind-app:v1"
      port = 3000
    }
  }
}

variable db_user {
  type = string
  default = "root"
}

variable db_password {
  type = string
  sensitive = true
}