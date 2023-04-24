variable "prefix" {
  description = "Name prefix for resources."
  type        = string
}

# cdn
variable "hosted_zone_domain" {
  description = "Domain name to use for the Route53 hosted zone."
  type        = string
}
variable "website_domain" {
  description = "Domain name to use for the website."
  type        = string
}
variable "enable_ip_address_blocking" {
  description = "Whether IP address blocking is enabled or not."
  type        = bool
}
variable "allowed_ip_addresses" {
  description = "Whether to create the default 404 error page."
  type        = set(string)
  default     = []
}
variable "enable_basic_auth" {
  description = "Whether basic authentication is enabled or not."
  type        = bool
}
variable "basic_auth_username" {
  description = "Username of the basic authentication."
  type        = string
  default     = null
}

# ecs
variable "create_ecs" {
  type    = bool
  default = true
}
variable "ecs_cluster_name" {
  type = string
}
variable "ecs_service_name" {
  type = string
}
variable "ecs_container_image" {
  type = string
}
variable "ecs_container_port" {
  type = number
}
variable "ecs_desired_count" {
  type    = number
  default = 1
}
variable "ecs_environment" {
  type    = set(map(string))
  default = []
}
variable "ecs_task_policy_arns" {
  type    = set(string)
  default = []
}

# lb
variable "lb_healthcheck_path" {
  type    = string
  default = "/"
}
variable "lb_delete_protection" {
  type    = bool
  default = true
}

# network
variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = set(string)
}
variable "private_subnet_ids" {
  type = set(string)
}
