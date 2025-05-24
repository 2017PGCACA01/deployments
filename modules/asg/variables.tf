variable "name" {
  description = "Name prefix"
  type        = string
}

variable "launch_template_id" {
  description = "Launch template ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "target_group_arns" {
  description = "Target group ARNs for the ALB"
  type        = list(string)
}

variable "max_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 1
}
