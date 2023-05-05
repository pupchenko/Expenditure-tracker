output "frontend_url" {
  value = aws_s3_bucket.bucket.website_endpoint
}

output "lb_dns_name" {
  value = aws_lb.demo-lb.dns_name
}
