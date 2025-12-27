output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public-1a.id, aws_subnet.public-1c.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = [aws_nat_gateway.nat-gw-1a.id, aws_nat_gateway.nat-gw-1c.id]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "The ID of the Public Route Table"
  value       = aws_route_table.public-rt.id
}

output "private_route_table_ids" {
  description = "List of Private Route Table IDs"
  value       = [aws_route_table.private-rt-1a.id, aws_route_table.private-rt-1c.id]
}
