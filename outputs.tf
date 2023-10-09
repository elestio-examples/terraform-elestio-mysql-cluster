output "nodes" {
  description = "This is the created nodes full information"
  value       = elestio_mysql.nodes
  sensitive   = true
}
