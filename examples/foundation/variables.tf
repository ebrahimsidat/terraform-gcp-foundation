variable "project_id" {
  description = "Project to build the foundation in."
  type        = string
}

variable "region" {
  description = "Default region."
  type        = string
  default     = "northamerica-northeast1"
}

variable "network_name" {
  description = "Name of the shared VPC network."
  type        = string
  default     = "core-vpc"
}

variable "subnets" {
  description = "Subnets keyed by name."

  type = map(object({
    region           = string
    ip_cidr_range    = string
    secondary_ranges = optional(map(string), {})
  }))
}

variable "role_members" {
  description = "IAM role to members map, applied additively."
  type        = map(list(string))
  default     = {}
}
