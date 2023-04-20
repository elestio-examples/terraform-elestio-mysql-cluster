variable "project_id" {
  type        = string
  nullable    = false
  description = <<-EOF
    Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#project_id) `#project_id`
  EOF
}


variable "server_name" {
  type        = string
  nullable    = false
  description = <<-EOF
    Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#server_name) `#server_name`
  EOF
}

variable "configs" {
  type = list(
    object({
      provider_name = string
      datacenter    = string
      server_type   = string
    })
  )
  nullable    = false
  description = <<-EOF
    Max 2 configs because only 2 nodes can be clustered safely.
    Optionnaly, you can specify a different config for the second node.
    See [providers list](https://registry.terraform.io/providers/elestio/elestio/latest/docs/guides/3_providers_datacenters_server_types)
  EOF

  validation {
    condition     = length(var.configs) == 1 || length(var.configs) == 2
    error_message = "You must fill in at least one configuration. A second configuration is optional if you want different options for the second node."
  }
}

variable "mysql_version" {
  type        = string
  nullable    = true
  description = <<-EOF
    Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#version) `#version`
  EOF
}

variable "support_level" {
  type        = string
  nullable    = false
  description = <<-EOF
    Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#support_level) `#support_level`
  EOF
}

variable "admin_email" {
  type        = string
  nullable    = false
  description = <<-EOF
    Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#admin_email) `#admin_email`
  EOF
}

variable "ssh_key" {
  type = object({
    key_name    = string
    public_key  = string
    private_key = string
  })
  nullable    = false
  sensitive   = true
  description = <<-EOF
    A local SSH connection is required to run the commands on all nodes to create the cluster.
  EOF
}
