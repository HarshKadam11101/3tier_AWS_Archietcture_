variable "vpc_id" {
  description = "The VPC in whcih the ASG needs to be launched in"
  type        = string
}

variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t3.micro"
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "app_sg" {
  description = "securtiy group for ASG"
  type        = string
}

variable "private_app_subnet" {
  description = "subnet for app"
  type        = list(string)
}

variable "target_group" {
  description = "target group"
  type        = string
}