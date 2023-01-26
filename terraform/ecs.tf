locals {
  image   = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.back_repo_name}"
  env_map = {
    "DB_URL"               = "jdbc:postgresql://${aws_db_instance.db.address}/${aws_db_instance.db.db_name}"
    "DB_USERNAME"          = aws_db_instance.db.username
    "DB_PASSWORD"          = aws_ssm_parameter.db_password.value
  }
  ports = [
    {
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    }
  ]
  logs_config = {
    "logDriver" = "awslogs"
    "options"   = {
      "awslogs-group"  = var.cloudwatch_group
      "awslogs-region" = var.region
      "awslogs-stream-prefix" : "ecs"
    }
  }
  cluster_name           = "demo-cluster"
  service_name           = "demo-service"
  container_name         = "demo-container"
  family_name            = "demo-t2-micro-family"
  capacity_provider_name = "demo-capacity-provider"
}

resource "aws_ecs_cluster" "demo_cluster" {
  name = local.cluster_name
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = local.capacity_provider_name
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.asg.arn
    managed_scaling {
      status          = "ENABLED"
      target_capacity = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "demo_cluster_capacity_provider" {
  cluster_name       = aws_ecs_cluster.demo_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }
}

module "container" {
  source                       = "registry.terraform.io/cloudposse/ecs-container-definition/aws"
  container_name               = local.container_name
  container_image              = local.image
  container_memory             = 512
  container_memory_reservation = 128
  container_cpu                = 512
  essential                    = true
  readonly_root_filesystem     = false
  map_environment              = local.env_map
  port_mappings                = local.ports
  log_configuration            = local.logs_config
  privileged                   = true
  interactive                  = true
  depends_on                   = [aws_db_instance.db, null_resource.prepare_backend_image]
}

resource "aws_ecs_task_definition" "demo-task" {
  family                = local.family_name
  container_definitions = module.container.json_map_encoded_list
  depends_on            = [aws_ecs_cluster.demo_cluster, module.container]
}

resource "aws_ecs_service" "service" {
  name            = local.service_name
  cluster         = aws_ecs_cluster.demo_cluster.id
  task_definition = aws_ecs_task_definition.demo-task.arn
  desired_count   = 1
  force_new_deployment = true
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = local.container_name
    container_port   = 8080
  }
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
}