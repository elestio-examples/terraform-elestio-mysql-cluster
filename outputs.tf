output "cluster_admin" {
  value       = module.cluster.nodes.*.database_admin
  description = "The information to access your clustered database"
  sensitive   = true
}
