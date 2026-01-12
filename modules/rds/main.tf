# RDS Instance

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "my_database"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az = true
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "my_rds_instance"
  }
}

# RDS Subnet Group

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds_subnet_group"
  subnet_ids  = var.db_subnet_ids

  tags = {
    Name = "rds_subnet_group"
  }
}

# RDS Security Group

resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "rds_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_ingress_rule" {
  security_group_id = aws_security_group.rds_security_group.id
  from_port        = 3306
  to_port          = 3306
  ip_protocol      = "tcp"
  referenced_security_group_id = var.ecs_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "rds_egress_rule" {
  security_group_id = aws_security_group.rds_security_group.id
  from_port        = 0
  to_port          = 0
  ip_protocol      = "-1"
  cidr_ipv4        = "0.0.0.0/0"
}
