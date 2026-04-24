variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the vpc"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "List of CIDR blocks for private app subnets"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "List of CIDR blocks for private db subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AZ's for the subnets"
  type        = list(string)
}

variable "env" {
  description = "Environment name"
  type        = string
}