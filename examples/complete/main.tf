data "aws_ecr_repository" "this" {
  name = "nextjs"
}

module "network" {
  source = "git@github.com:ccscshq/terraform-aws-network.git?ref=v0.1.0"

  prefix                 = local.prefix
  ipv4_cidr              = local.ipv4_cidr
  ipv4_cidr_newbits      = local.ipv4_cidr_newbits
  subnets_number         = local.subnets_number
  create_private_subnets = true
}

module "ssr" {
  source = "../../"

  providers = {
    aws.virginia = aws.virginia
  }

  prefix = local.prefix
  # cdn
  hosted_zone_domain         = "example.com"
  website_domain             = "ssr.example.com"
  enable_ip_address_blocking = false
  allowed_ip_addresses       = []
  enable_basic_auth          = false
  basic_auth_username        = null
  # ecs
  ecs_cluster_name     = "ccscshq-ssr"
  ecs_service_name     = "ssr"
  ecs_container_image  = "${data.aws_ecr_repository.this.repository_url}:latest"
  ecs_container_port   = 3000
  ecs_desired_count    = 2
  ecs_environment      = []
  ecs_task_policy_arns = []
  ecs_cpu_architecture = "X86_64"
  # lb
  lb_healthcheck_path  = "/"
  lb_delete_protection = false
  # network
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
}
