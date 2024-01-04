output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

output "server_port" {
  value       = var.server_port
  description = "Webserver port"
}