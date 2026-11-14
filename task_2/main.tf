terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
  required_version = "~>1.17.0" /*Многострочный комментарий.
 Требуемая версия terraform */
}

provider "docker" {
  context = "terraform-vm"
}

#однострочный комментарий

resource "random_password" "root_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql_container" {
  image = docker_image.mysql.image_id
  name  = "mysql"

  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }

 env = [
     "MYSQL_ROOT_PASSWORD=${random_password.root_password.result}",
     "MYSQL_DATABASE=wordpress",
     "MYSQL_USER=wordpress",
     "MYSQL_PASSWORD=${random_password.password.result}",
     "MYSQL_ROOT_HOST=%"
 ]  
}
