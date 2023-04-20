module "simple_example_cluster" {
  source = "elestio-examples/mysql-cluster/elestio"

  project_id    = "1234"
  server_name   = "mysql"
  mysql_version = 8
  support_level = "level1"
  admin_email   = "admin@example.com"
  configs = [
    {
      provider_name = "hetzner"
      datacenter    = "fsn1"
      server_type   = "SMALL-1C-2G"
    },
    # This following config is optional, only if you want a different config for the second node
    {
      provider_name = "lightsail"
      datacenter    = "eu-west-1"
      server_type   = "MICRO-1C-1G"
    },
  ]
  ssh_key = {
    key_name    = "admin"
    public_key  = file("~/.ssh/id_rsa.pub")
    private_key = file("~/.ssh/id_rsa")
  }
}
