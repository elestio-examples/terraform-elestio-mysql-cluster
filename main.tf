resource "elestio_mysql" "nodes" {
  for_each = { for value in var.nodes : value.server_name => value }

  project_id       = var.project_id
  version          = var.mysql_version
  default_password = var.mysql_pass
  server_name      = each.value.server_name
  provider_name    = each.value.provider_name
  datacenter       = each.value.datacenter
  server_type      = each.value.server_type
  // Merge the module configuration_ssh_key with the optional ssh_public_keys attribute
  ssh_public_keys = concat(each.value.ssh_public_keys, [{
    username = var.configuration_ssh_key.username
    key_data = var.configuration_ssh_key.public_key
  }])

  // Optional attributes
  admin_email                                       = each.value.admin_email
  alerts_enabled                                    = each.value.alerts_enabled
  app_auto_updates_enabled                          = each.value.app_auto_update_enabled
  backups_enabled                                   = each.value.backups_enabled
  firewall_enabled                                  = each.value.firewall_enabled
  keep_backups_on_delete_enabled                    = each.value.keep_backups_on_delete_enabled
  remote_backups_enabled                            = each.value.remote_backups_enabled
  support_level                                     = each.value.support_level
  system_auto_updates_security_patches_only_enabled = each.value.system_auto_updates_security_patches_only_enabled

  connection {
    type        = "ssh"
    host        = self.ipv4
    private_key = var.configuration_ssh_key.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "cd /opt/app",
      "docker-compose down",
    ]
  }
}

resource "random_id" "server_id" {
  for_each    = { for node in elestio_mysql.nodes : node.server_name => node.id }
  byte_length = 2
}

resource "null_resource" "update_nodes_env" {
  for_each = { for node in elestio_mysql.nodes : node.server_name => node }

  triggers = {
    nodes = join(",",
      [for server_id in random_id.server_id : server_id.dec],
      [for node in elestio_mysql.nodes : node.id],
      [for node in elestio_mysql.nodes : node.ipv4],
      [for node in elestio_mysql.nodes : node.global_ip],
      [for node in elestio_mysql.nodes : node.database_admin.port],
      [for node in elestio_mysql.nodes : node.database_admin.user],
      [for node in elestio_mysql.nodes : node.database_admin.password],
    )
  }

  connection {
    type        = "ssh"
    host        = each.value.ipv4
    private_key = var.configuration_ssh_key.private_key
  }

  provisioner "file" {
    destination = "/opt/clustermode.conf"
    content = templatefile("${path.module}/resources/clustermode.conf.tftpl", {
      target_global_ip = elestio_mysql.nodes[[for n in elestio_mysql.nodes : n.server_name if n.server_name != each.value.server_name][0]].global_ip
      target_port      = elestio_mysql.nodes[[for n in elestio_mysql.nodes : n.server_name if n.server_name != each.value.server_name][0]].database_admin.port
    })
  }

  provisioner "remote-exec" {
    inline = [
      "cd /opt/app",
      "docker-compose down",
      "sed -i \"/CLUSTER_OPTIONS=/c\\CLUSTER_OPTIONS=--server-id=${random_id.server_id[each.value.server_name].dec} --report-host=${elestio_mysql.nodes[[for n in elestio_mysql.nodes : n.server_name if n.server_name != each.value.server_name][0]].global_ip} --auto-increment-increment=2 --auto-increment-offset=1\" .env",
      "docker-compose up -d",
      "sleep 15s",
      "docker-compose exec -T mysql mysql -h 172.17.0.1 --port ${each.value.database_admin.port} -u ${each.value.database_admin.user} -p${each.value.database_admin.password} -e \"stop slave;\"",
      "docker-compose exec -T mysql mysql -h 172.17.0.1 --port ${each.value.database_admin.port} -u ${each.value.database_admin.user} -p${each.value.database_admin.password} -e \"CHANGE MASTER TO MASTER_HOST='${elestio_mysql.nodes[[for n in elestio_mysql.nodes : n.server_name if n.server_name != each.value.server_name][0]].global_ip}', MASTER_PORT=${elestio_mysql.nodes[[for n in elestio_mysql.nodes : n.server_name if n.server_name != each.value.server_name][0]].database_admin.port}, MASTER_USER='${elestio_mysql.nodes[[for n in elestio_mysql.nodes : n.server_name if n.server_name != each.value.server_name][0]].database_admin.user}', MASTER_PASSWORD='${elestio_mysql.nodes[[for n in elestio_mysql.nodes : n.server_name if n.server_name != each.value.server_name][0]].database_admin.password}', MASTER_AUTO_POSITION=1;\"",
      "docker-compose exec -T mysql mysql -h 172.17.0.1 --port ${each.value.database_admin.port} -u ${each.value.database_admin.user} -p${each.value.database_admin.password} -e \"reset slave;\"",
      "docker-compose exec -T mysql mysql -h 172.17.0.1 --port ${each.value.database_admin.port} -u ${each.value.database_admin.user} -p${each.value.database_admin.password} -e \"start slave;\"",
      "docker-compose exec -T mysql mysql -h 172.17.0.1 --port ${each.value.database_admin.port} -u ${each.value.database_admin.user} -p${each.value.database_admin.password} -e \"show slave status;\"",
    ]
  }
}
