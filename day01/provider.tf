terraform {
  // to specify the required terraform version
  required_version = "> 1.2"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.17.0"
    }
  }

  // to store the state file in digitalocean spaces
  // run apply_credentials.sh first to export the access key and access id
  backend s3 {
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    endpoint = "https://sgp1.digitaloceanspaces.com"
    region = "sgp1"
    bucket = "my-aipc"
    key = "aipc/terraform.tfstate"
  }
}

provider "digitalocean" {
  token = var.DO_token
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}