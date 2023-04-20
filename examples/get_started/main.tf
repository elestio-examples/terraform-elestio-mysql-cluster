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
  name             = "cluster mysql"
  technical_emails = var.elestio_email
}

module "cluster" {
  source = "../../"

  project_id    = elestio_project.project.id
  server_name   = "mysql"
  mysql_version = 8
  support_level = "level1"
  admin_email   = var.elestio_email

  configs = [
    {
      provider_name = "hetzner"
      datacenter    = "fsn1"
      server_type   = "SMALL-1C-2G"
    },
    # {
    #   provider_name = "lightsail"
    #   datacenter    = "eu-west-1"
    #   server_type   = "MICRO-1C-1G"
    # },
    # Max 2 configs because only 2 nodes can be clustered safely
    # Optionnaly, you can specify a different config for the second node
    # Read providers list: https://registry.terraform.io/providers/elestio/elestio/latest/docs/guides/3_providers_datacenters_server_types
  ]

  ssh_key = {

    key_name    = "admin"                   # or var.ssh_key.name
    public_key  = file("~/.ssh/id_rsa.pub") # or var.ssh_key.public_key
    private_key = file("~/.ssh/id_rsa")     # or var.ssh_key.private_key
    # See `variables.tf` and `secrets.tfvars` file comments if your want to use variables.
  }

}

output "cluster_admin" {
  value     = module.cluster.nodes.*.database_admin
  sensitive = true
}
