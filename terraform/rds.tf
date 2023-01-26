resource "random_password" "random_db_password" {
  length  = 8
  special = false
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/demo-evn/postgres/password/master"
  description = "Random secret db password"
  type        = "SecureString"
  value       = random_password.random_db_password.result
}

resource "aws_db_instance" "db" {
  engine                  = "postgres"
  engine_version          = "13.7"
  instance_class          = "db.t3.micro"
  db_name                 = "expensetracker"
  identifier              = "postgres"
  username                = "root"
  password                = random_password.random_db_password.result
  publicly_accessible     = false
  db_subnet_group_name    = module.vpc.database_subnet_group_name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  allocated_storage       = 50
  max_allocated_storage   = 1000
  backup_retention_period = 0
}
