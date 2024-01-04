/*
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}
*/

output "asg_name" {
  value = aws_autoscaling_group.example.name
  description = "Name of the Auto Scaling Group"
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "Domain name of the load balancer"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
  description = "ID of the security group attached to LB"
}