output "ALB_DNS_Name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.Guestbook_ALB.dns_name
}