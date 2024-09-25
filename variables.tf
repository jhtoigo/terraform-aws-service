variable "name" {
  description = "Application name"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Type of environment dev/prod"
  type        = string
  default     = "dev"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
}

## Tasks

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "container_environments" {
  description = "Map of variables and static values to add to the task definition"
  type        = map(string)
  default     = {}
}

variable "container_secrets" {
  type        = map(string)
  description = "Map of variables and SSM locations to add to the task definition"
  default     = {}
}

variable "healthCheck" {
  type        = any
  description = "Container Health Check parameters"
  default     = {}
}

variable "container_memory" {
  description = "Container memory definition"
  type        = number
}

variable "container_cpu" {
  description = "Container CPU Definition"
  type        = number
}

## Service

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the service configuration"
  type        = string
}

variable "container_port" {
  description = "Port to expose on host"
  type        = number
}

variable "desired_count" {
  description = "Number of desired tasks running in service"
  type        = number
  default     = 1
}

variable "min_capacity" {
  description = "Min scaling service capcity"
  type        = number
  default     = null
}

variable "max_capacity" {
  description = "Max scaling service capcity"
  type        = number
  default     = null
}

variable "schedule" {
  description = "A list of objects defining the schedule-based auto scaling settings for ECS. Each object should specify the minimum and maximum capacity along with the schedule in cron format."
  default     = []
  type = list(
    object({
      min_capacity = number
      max_capacity = number
      schedule     = string
      }
    )
  )
}

variable "capacity_provider_strategies" {
  description = "List of capacity providers for this service"
  default = [{
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 100
  }]
  type = list(object({
    capacity_provider = string
    base              = number
    weight            = number
  }))
}

variable "mongodb_egress" {
  description = "Create a egress rule for MongoDB to database subnet"
  type        = bool
  default     = false
}

variable "postgres_egress" {
  description = "Create a egress rule for Postgresql to database subnet"
  type        = bool
  default     = true
}