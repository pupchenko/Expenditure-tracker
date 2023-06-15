variable "region" {
  type    = string
  default = "eu-west-1"
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
  default = "/ecs/expense-tracker-backend"
}

variable "backend-application_name" {
  type    = string
  default = "expense-tracker-backend"
}

variable "frontend_bucket_name" {
  type    = string
  default = "expense-tracker-react-app"
}
