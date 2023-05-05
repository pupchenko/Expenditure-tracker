variable "region" {
  type    = string
  default = "us-east-1"
}

variable "back_repo_name" {
  type    = string
  default = "expense-tracker-backend"
}

variable "front_repo_name" {
  type    = string
  default = "expense-tracker-react"
}

variable "cloudwatch_group" {
  type    = string
  default = "/ecs/micronaut-app"
}

variable "backend-application_name" {
  type    = string
  default = "expense-tracker-backend"
}

variable "frontend_bucket_name" {
  type    = string
  default = "expense-tracker-react-app"
}
