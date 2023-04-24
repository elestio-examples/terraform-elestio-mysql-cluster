# Get started : MySQL Cluster with Terraform and Elestio

In this example, you will learn how to use this module to deploy your own MySQL cluster with Elestio.

Some knowledge of [terraform](https://developer.hashicorp.com/terraform/intro) is recommended, but if not, the following instructions are sufficient.

## Prepare the dependencies

- [Sign up for Elestio if you haven't already](https://dash.elest.io/signup)

- [Get your API token in the security settings page of your account](https://dash.elest.io/account/security)

- [Download and install Terraform](https://www.terraform.io/downloads)

  You need a Terraform CLI version equal or higher than v0.14.0.
  To ensure you're using the acceptable version of Terraform you may run the following command: `terraform -v`

## Instructions

1. Rename `secrets.tfvars.example` to `secrets.tfvars` and fill in the values.

   This file contains the sensitive values to be passed as variables to Terraform.</br>
   You should **never commit this file** with git.

2. Run terraform with the following commands:

   ```bash
   terraform init
   terraform plan -var-file="secrets.tfvars" # to preview changes
   terraform apply -var-file="secrets.tfvars"
   terraform show
   ```

3. You can use the `terraform output` command to print the output block of your main.tf file:

   ```bash
   terraform output cluster_admin # PHPMyAdmin secrets
   terraform output cluster_database_admin # Database secrets
   ```

## Testing

Use `terraform output cluster_admin` command to output PHPMyAdmin secrets:

```bash
# cluster_admin
[
  {
    "password" = "...."
    "url" = "https://mysql-0-u525.vm.elestio.app:24580/"
    "user" = "root"
  },
  {
    "password" = "..."
    "url" = "https://mysql-1-u525.vm.elestio.app:24580/"
    "user" = "root"
  },
]
```

Log in to both URLs with the credentials.

Create a database on the first node.
You should see it automatically appear on the second node a few seconds later.

You can try turning off the first node on the [Elestio dashboard](https://dash.elest.io/).
The second node remains functional.
When you restart it, it automatically updates with the new data.

## How to use Multi-Master cluster

If you can configure your two master clusters in Round Robin in your MySQL driver, a load balancer is not needed. The client-side will split the traffic between your instances and avoid a dead node. This helps to greatly simplify the high-availability system.

- [Node.js](https://www.npmjs.com/package/mysql#poolcluster)
- [Java](https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-source-replica-replication-connection.html)
