variable "project_id" {
  type        = string
  description = "The ID of the project in which the two MySQL nodes will be created"
  nullable    = false
}


variable "server_name" {
  type        = string
  description = "https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#server_name"
  nullable    = false
}

variable "configs" {
  type = list(
    object({
      provider_name = string
      datacenter    = string
      server_type   = string
    })
  )
  nullable = false
  validation {
    condition     = length(var.configs) == 1 || length(var.configs) == 2
    error_message = "You must fill in at least one configuration. A second configuration is optional if you want different options for the second node."
  }
}

variable "mysql_version" {
  type        = string
  nullable    = true
  description = "https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#version"
}

variable "support_level" {
  type        = string
  nullable    = false
  description = "https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#support_level"
}

variable "admin_email" {
  type        = string
  nullable    = false
  description = "https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#admin_email"
}

variable "ssh_key" {
  type = object({
    key_name    = string
    public_key  = string
    private_key = string
  })
  nullable    = false
  sensitive   = true
  description = "A local SSH connection is required to run the commands on all nodes to create the cluster."
}
