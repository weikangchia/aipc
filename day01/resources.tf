// terraform uses underscore, so we can't use underscore
// <provider_name>_ssh_key
data "digitalocean_ssh_key" "aipc" {
  name = "aipc"
}

resource local_file aipc_public_key {
  filename = "aipc.pub"
  content = data.digitalocean_ssh_key.aipc.public_key
  file_permission = "0644"
}

output aipc_ssh_key_fingerprint {
  value = data.digitalocean_ssh_key.aipc.fingerprint
}

output aipc_ssh_key_id {
  value = data.digitalocean_ssh_key.aipc.id
}

data "docker_image" "dovbear" {
  name = "chukmunnlee/dov-bear:v2"
}

output dov-bear-md5 {
  value = data.docker_image.dovbear.repo_digest
  description = "SHA of the image"
}

// option 1
# resource "docker_container" "dovbear-container" {
#   count = length(var.ports)
#   name = "dovbear-${count.index}"
#   image = data.docker_image.dovbear.id
#   env = [
#     "INSTANCE_NAME=myapp-${count.index}",
#     "INSTANCE_HASH=${count.index}"
#   ]
#   ports {
#     internal = 3000
#     external = var.ports[count.index]
#   }
# }

// option 2
resource "docker_container" "dovbear-container" {
  for_each = var.containers
  name = "dovbear-${each.key}"
  image = data.docker_image.dovbear.id
  env = [
    "INSTANCE_NAME=myapp-${each.key}",
    "INSTANCE_HASH=${each.key}"
  ]
  ports {
    internal = 3000
    external = each.value.external_port
  }
}

output container-names {
  value = [ for c in docker_container.dovbear-container: c.name ]
}

resource local_file container-names {
  content = join(", ", [ for c in docker_container.dovbear-container: c.name ])
  filename = "containers.txt"
  file_permission = "0644"
}