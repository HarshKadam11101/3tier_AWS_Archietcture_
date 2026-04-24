output "vpc_id" {
  value = aws_vpc.primary_vpc.id
}

output "public_subnet" {
  value = aws_subnet.public-subnet[*].id
}

output "private_app_subnet" {
  value = aws_subnet.private_app_subnet[*].id
}

output "private_db_subnet" {
  value = aws_subnet.private_db_subnet[*].id
}