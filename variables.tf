variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
}
