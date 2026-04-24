output "url" {
  value       = "http://${module.alb.dns_name}"
  description = "Website url"
}

output "db_endpoint" {
  value       = module.rds.aws_db_endpoint
  description = "db url"
}