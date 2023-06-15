data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "backend_repo" {
  name         = var.back_repo_name
  force_delete = true
}

resource "null_resource" "prepare_backend_image" {
  provisioner "local-exec" {
    command = "docker build -t ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.back_repo_name} ../${var.backend-application_name}"
  }
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  }
  provisioner "local-exec" {
    command = "docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.back_repo_name}"
  }
  depends_on = [aws_ecr_repository.backend_repo]
}

resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "cd ../${var.front_repo_name} && npm i && REACT_APP_BACKEND_URL=${aws_lb.demo-lb.dns_name} npm run build"
  }
  depends_on = [aws_s3_bucket.bucket]
}

resource "null_resource" "deploy" {
  provisioner "local-exec" {
    command = "aws s3 sync ../${var.front_repo_name}/build/ s3://${var.frontend_bucket_name}"
  }
  depends_on = [null_resource.build]
}


