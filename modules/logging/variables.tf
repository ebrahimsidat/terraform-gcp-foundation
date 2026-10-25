variable "project_id" {
  description = "Project whose logs are routed to the audit bucket."
  type        = string
}

variable "location" {
  description = "Location of the log bucket, for example northamerica-northeast1 or global."
  type        = string
  default     = "global"
}

variable "bucket_id" {
  description = "ID of the log bucket."
  type        = string
  default     = "audit-logs"
}

variable "retention_days" {
  description = "Number of days to retain logs (1 to 3650)."
  type        = number
  default     = 400

  validation {
    condition     = var.retention_days >= 1 && var.retention_days <= 3650
    error_message = "retention_days must be between 1 and 3650."
  }
}

variable "sink_filter" {
  description = "Logging filter selecting the entries routed to the audit bucket."
  type        = string
  default     = "logName:\"cloudaudit.googleapis.com\" OR log_id(\"compute.googleapis.com/firewall\")"
}

variable "enable_data_access_logs" {
  description = "Enable Data Access audit logs (ADMIN_READ, DATA_READ, DATA_WRITE) for all services."
  type        = bool
  default     = true
}
