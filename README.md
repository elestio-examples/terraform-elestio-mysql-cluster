<!-- BEGIN_TF_DOCS -->
# Elestio MySQL Cluster Terraform module

Using this module, you can easily and quickly deploy a MySQL Cluster on Elestio that is configured correctly and ready to use, without spending a lot of time on manual configuration.



This module deploy 2 MySQL nodes on Elestio and commands are automatically executed to link them using the multi-master feature.

## Usage

There is a ready-to-deploy example included in the [examples](https://github.com/elestio-examples/terraform-elestio-mysql-cluster/tree/main/examples) folder but simple usage is as follows:

```hcl
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
```

## Examples

- [Get Started](https://github.com/elestio-examples/terraform-elestio-mysql-cluster/tree/main/examples/get_started) - Ready-to-deploy example which creates MySQL Cluster on Elestio with Terraform in 5 minutes.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#admin_email) `#admin_email` | `string` | n/a | yes |
| <a name="input_configs"></a> [configs](#input\_configs) | Max 2 configs because only 2 nodes can be clustered safely.<br>Optionnaly, you can specify a different config for the second node.<br>See [providers list](https://registry.terraform.io/providers/elestio/elestio/latest/docs/guides/3_providers_datacenters_server_types) | <pre>list(<br>    object({<br>      provider_name = string<br>      datacenter    = string<br>      server_type   = string<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#version) `#version` | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#project_id) `#project_id` | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#server_name) `#server_name` | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | A local SSH connection is required to run the commands on all nodes to create the cluster. | <pre>object({<br>    key_name    = string<br>    public_key  = string<br>    private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_support_level"></a> [support\_level](#input\_support\_level) | Related [documentation](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql#support_level) `#support_level` | `string` | n/a | yes |
## Modules

No modules.
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_admin"></a> [cluster\_admin](#output\_cluster\_admin) | The information to access your clustered database |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_elestio"></a> [elestio](#provider\_elestio) | >= 0.7.1 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.0 |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_elestio"></a> [elestio](#requirement\_elestio) | >= 0.7.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.0 |
## Resources

| Name | Type |
|------|------|
| [elestio_mysql.nodes](https://registry.terraform.io/providers/elestio/elestio/latest/docs/resources/mysql) | resource |
| [null_resource.cluster_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
<!-- END_TF_DOCS -->
