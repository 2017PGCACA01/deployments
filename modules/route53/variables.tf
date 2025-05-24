variable "zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "record_name" {
  description = "Domain record to create (e.g., app.example.com)"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Hosted zone ID of the ALB"
  type        = string
}
