source digitalocean mydroplet {
  api_token = var.DO_token
  image = "ubuntu-20-04-x64"
  size = "s-1vcpu-1gb"
  region = "sgp1"
  ssh_username = "root"
  snapshot_name = "codeserver:${var.codeserver_version}"
}

build {
  sources = ["source.digitalocean.mydroplet"]

  provisioner ansible {
    playbook_file = "playbook.yaml"
    extra_arguments = [
      "-e", "codeserver_version=${var.codeserver_version}"
    ]
  }
}