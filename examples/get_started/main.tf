terraform {
  required_providers {
    elestio = {
      source = "elestio/elestio"
    }
  }
}

provider "elestio" {
  email     = var.elestio_email
  api_token = var.elestio_api_token
}

resource "elestio_project" "project" {
  name = "mysql-cluster"
}


module "cluster" {
  source = "elestio-examples/mysql-cluster/elestio"

  project_id    = elestio_project.project.id
  mysql_version = null # null means latest version
  mysql_pass    = var.mysql_pass

  configuration_ssh_key = {
    username    = "admin"
    public_key  = chomp(file("~/.ssh/id_rsa.pub"))
    private_key = file("~/.ssh/id_rsa")
  }

  nodes = [
    {
      server_name   = "mysql-1"
      provider_name = "hetzner"
      datacenter    = "fsn1"
      server_type   = "SMALL-1C-2G"
    },
    {
      server_name   = "mysql-2"
      provider_name = "hetzner"
      datacenter    = "fsn1"
      server_type   = "SMALL-1C-2G"
    },
  ]
}

output "nodes_admins" {
  value     = { for node in module.cluster.nodes : node.server_name => node.admin }
  sensitive = true
}

output "nodes_database_admins" {
  value     = { for node in module.cluster.nodes : node.server_name => node.database_admin }
  sensitive = true
}
