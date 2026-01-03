variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive = true
}

variable "db_subnet_ids" {
  description = "The IDs of the subnets for the RDS instance"
  type        = list(string)
}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
}

variable "ecs_security_group_id" {
    description = "The security group for the ECS cluster"
    type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC for the RDS instance"
  type        = string
}
