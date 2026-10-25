variable "project_id" {
  description = "Project to which the IAM bindings are applied."
  type        = string
}

variable "role_members" {
  description = "Map of IAM role to the list of members granted that role, for example group:ops@example.com."
  type        = map(list(string))
  default     = {}

  validation {
    condition = alltrue(flatten([
      for members in values(var.role_members) : [
        for m in members : can(regex("^(user|group|serviceAccount|domain):", m))
      ]
    ]))
    error_message = "Members must start with user:, group:, serviceAccount: or domain:."
  }

  validation {
    condition     = !contains(keys(var.role_members), "roles/owner")
    error_message = "roles/owner must not be granted through this module; use narrower predefined roles."
  }
}
