variable "project_id" {
  description = "Project in which to enable the APIs."
  type        = string
}

variable "services" {
  description = "Google Cloud APIs to enable, for example compute.googleapis.com."
  type        = list(string)

  validation {
    condition     = alltrue([for s in var.services : endswith(s, ".googleapis.com")])
    error_message = "Each service must be a fully qualified API name ending in .googleapis.com."
  }
}
