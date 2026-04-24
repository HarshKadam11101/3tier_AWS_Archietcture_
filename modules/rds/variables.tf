variable "private_db_subnet" {
  description = "subnet in which db is deployed"
  type        = list(string)
}


variable "db_sg" {
  description = "the security group of db"
  type        = string
}

variable "env" {
  description = "Environment value"
  type        = string
}

variable "db_user" {
  description = "DB user name"
  default     = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}