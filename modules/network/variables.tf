variable "project_id" {
  description = "Project that hosts the VPC network."
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network."
  type        = string

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$", var.network_name))
    error_message = "network_name must be a valid RFC 1035 name (lowercase letters, digits and hyphens)."
  }
}

variable "routing_mode" {
  description = "Dynamic routing mode for Cloud Routers: REGIONAL or GLOBAL."
  type        = string
  default     = "GLOBAL"

  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], var.routing_mode)
    error_message = "routing_mode must be REGIONAL or GLOBAL."
  }
}

variable "subnets" {
  description = "Subnets keyed by name. Secondary ranges are optional (for example GKE pod and service ranges)."

  type = map(object({
    region           = string
    ip_cidr_range    = string
    secondary_ranges = optional(map(string), {})
  }))

  validation {
    condition     = alltrue([for s in values(var.subnets) : can(cidrnetmask(s.ip_cidr_range))])
    error_message = "Every subnet ip_cidr_range must be a valid IPv4 CIDR block."
  }
}

variable "flow_log_sampling" {
  description = "Fraction of VPC flow logs to sample (0.0 to 1.0)."
  type        = number
  default     = 0.5

  validation {
    condition     = var.flow_log_sampling >= 0 && var.flow_log_sampling <= 1
    error_message = "flow_log_sampling must be between 0 and 1."
  }
}

variable "enable_cloud_nat" {
  description = "Create a Cloud Router and Cloud NAT in every region that has a subnet."
  type        = bool
  default     = true
}

variable "iap_ssh_target_tags" {
  description = "Network tags of instances reachable over SSH through Identity-Aware Proxy. Empty disables the rule."
  type        = list(string)
  default     = ["allow-iap-ssh"]
}
