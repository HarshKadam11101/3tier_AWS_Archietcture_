variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "webappdb"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true # CRITICAL for security
}