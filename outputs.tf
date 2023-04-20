output "cluster_nodes" {
  value       = elestio_mysql.nodes
  description = "All the information of the nodes in the cluster"
  sensitive   = true
}

output "cluster_admin" {
  value       = elestio_mysql.nodes.*.admin
  description = "The URL and secrets to connect to PHPMyAdmin on both nodes"
  sensitive   = true
}

output "cluster_database_admin" {
  value       = elestio_mysql.nodes.*.admin
  description = "The database connection string/command for both nodes"
  sensitive   = true
}
