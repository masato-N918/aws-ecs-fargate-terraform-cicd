# Security Group for ECS

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_security_group"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_sg_ingress" {
  security_group_id = aws_security_group.ecs_sg.id
  from_port        = 80
  to_port          = 80
  ip_protocol      = "tcp"
  referenced_security_group_id = var.alb_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "ecs_sg_egress" {
  security_group_id = aws_security_group.ecs_sg.id
  from_port        = 0
  to_port          = 0
  ip_protocol      = "-1"
  cidr_ipv4     = ["0.0.0.0/0"]
}

# ECS Task Definition

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "my_ecs_task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "my_container"
      image     = "nginx:latest"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    },
    {
      name     = "sidecar_container"
      image    = var.sidecar_image_url
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs-sidecar"
        }
      }
        portMappings = [
            {
            containerPort = 8080
            protocol      = "tcp"
            }
        ]
    }
  ])

  tags = {
    Name = "my_ecs_task_definition"
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "ecs_task_execution_role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch Log Group for ECS

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/my_ecs_task"
  retention_in_days = 7

  tags = {
    Name = "ecs_log_group"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my_ecs_cluster"

  tags = {
    Name = "my_ecs_cluster"
  }
}

# ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = "my_ecs_service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "my_container"
    container_port   = 80
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]

  tags = {
    Name = "my_ecs_service"
  }
}
