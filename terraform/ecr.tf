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

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}
data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = var.frontend_bucket_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket        = var.frontend_bucket_name
  force_destroy = true
}


