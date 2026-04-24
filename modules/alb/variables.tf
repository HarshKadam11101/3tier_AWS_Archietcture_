variable "alb_sg" {
  description = "security group for ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC in which ALB needs to be placed"
  type        = string
}

variable "env" {
  description = "Environment value"
  type        = string
}

variable "public_subnet" {
  description = "value"
  type        = list(string)
}