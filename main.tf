resource "elestio_mysql" "nodes" {
  count         = 2
  project_id    = var.project_id
  server_name   = "${var.server_name}-${count.index}"
  provider_name = length(var.configs) == 1 ? var.configs[0].provider_name : var.configs[count.index].provider_name
  datacenter    = length(var.configs) == 1 ? var.configs[0].datacenter : var.configs[count.index].datacenter
  server_type   = length(var.configs) == 1 ? var.configs[0].server_type : var.configs[count.index].server_type
  version       = var.mysql_version
  support_level = var.support_level
  admin_email   = var.admin_email
  ssh_keys = [
    {
      key_name   = var.ssh_key.key_name
      public_key = var.ssh_key.public_key
    },
  ]
  keep_backups_on_delete_enabled = true
}

resource "null_resource" "cluster_configuration" {
  depends_on = [
    elestio_mysql.nodes
  ]

  provisioner "local-exec" {
    command = templatefile("${path.module}/scripts/setup_cluster.sh.tftpl", {
      nodes           = elestio_mysql.nodes
      ssh_private_key = nonsensitive(var.ssh_key.private_key)
    })
  }
}
