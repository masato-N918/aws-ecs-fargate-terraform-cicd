terraform {
  backend "s3" {
    bucket = "aws-ecs-fargate-terraform-cicd"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}
