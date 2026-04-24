resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-db-subnet"
  subnet_ids = var.private_db_subnet

  tags = {
    Name = "${var.env}-db-subnet"
  }
}

resource "aws_db_instance" "db" {
  identifier        = "${var.env}-database"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg]

  multi_az = true

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "${var.env}-database_instance"
  }
}