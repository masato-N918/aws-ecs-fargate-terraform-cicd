output "ecs_security_group_id" {
    value = aws_security_group.ecs_sg.id
}

output "ecs_task_definition_arn" {
    value = aws_ecs_task_definition.ecs_task.arn
}
