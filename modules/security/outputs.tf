output "alb-sg" {
  value = aws_security_group.alb_sg.id
}

output "app-sg" {
  value = aws_security_group.private_app_sg.id
}

output "db-sg" {
  value = aws_security_group.private_db_sg.id
}