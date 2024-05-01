
resource "aws_iam_policy" "task_policy" {
  name        = "ltk-ecs-task-policy"
  description = "Task policy for ECS"

  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ],
        Resource = [
          aws_cloudwatch_log_group.ltk_encompdev_api_log_group.arn
        ]
      }
    ]
  })
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.identifier}-cluster"
  tags = local.tags
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.identifier}-execution-role"
  managed_policy_arns = [
    data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.identifier}-task-role"
  managed_policy_arns = [
    aws_iam_policy.task_policy.arn,
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_cloudwatch_log_group" "cw_log_group" {
  name              = "your-log-group-name"
  retention_in_days = 30
  tags              = local.tags
}

resource "aws_cloudwatch_log_stream" "cw_log_group_stream" {
  name           = "your-cw-log-group-name"
  log_group_name = aws_cloudwatch_log_group.ltk_encompdev_api_log_group.name
}

resource "aws_ecs_task_definition" "ltk_encompdev_api_task_definition" {
  family                   = "your-task-defintion-name"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ltk_encompdev_api_config.task_cpu
  memory                   = var.ltk_encompdev_api_config.task_memory
  container_definitions = jsonencode(
    [
    {
      name      = "ltk-encompdev-api"
      image     = "nginx:latest"
      cpu       = var.ltk_encompdev_api_config.container_cpu
      memory    = var.ltk_encompdev_api_config.container_memory
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ltk_encompdev_api_log_group.name
          awslogs-stream-prefix = aws_cloudwatch_log_stream.ltk_encompdev_api_log_stream.name
          awslogs-region        = data.aws_region.current.name
        }
      }
      environment = [
        {
          "name" : "COMPlus_EnableDiagnostics",
          "value" : "0"
        }
      ]
    }],
    [{
      name  = "datadog-agent"
      image = "datadog/agent:latest"
      environment = [
        {
          name  = "DD_API_KEY"
          value = var.dd_api_key
        },
        {
          name  = "ECS_FARGATE"
          value = "true"
        },
        {
          name  = "DD_APM_ENABLED",
          value = "true"
        },
        {
          name  = "DD_APM_NON_LOCAL_TRAFFIC",
          value = "true"
        },
        {
          name = "DD_ENV"
          value = data.aws_default_tags.default_tags.tags.Environment
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ltk_encompdev_api_log_group.name
          awslogs-stream-prefix = "datadog"
          awslogs-region        = data.aws_region.current.name
        }
      }
    }]
  )

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = local.tags
}

resource "aws_ecs_service" "ltk_encompdev_api_service" {
  name                               = "ltk-encompdev-api-${terraform.workspace}"
  enable_execute_command             = true
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.ltk_encompdev_api_task_definition.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 50
  tags                               = local.tags

  network_configuration {
    subnets         = ["your-subnet-id"] //Add your subnet id here
    security_groups = ["your-sg-id"] //Add your security group id here
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

}

resource "aws_iam_role" "dd_lambda_execution_role" {
  name = "${var.identifier}-datadogLambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "datadog_forwarder_lambda_policy" {
  name        = "${var.identifier}-DataDogLambdaExecutionPolicy"
  description = "Policy for Lambda Execution"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*" 
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dd_lambda_policy_attachment" {
 role        = aws_iam_role.dd_lambda_execution_role.name
 policy_arn  = aws_iam_policy.datadog_forwarder_lambda_policy.arn
}

module "datadog" {
  source = "./modules/datadog"
  resource_name = each.key
  lambda_environment_variables = merge({
    DD_API_KEY = var.dd_api_key
  },
  {
    DD_TAGS = each.value.custom_tags
  })
  identifier = local.identifier
  lambda_execution_role  = aws_iam_role.dd_lambda_execution_role.arn
  log_group_configuration = each.value.log_group_name
}

module "dd_monitors" {
  source = "./modules/datadog_monitoring"
  monitor_settings = var.monitor_settings
}