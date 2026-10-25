output "bindings" {
  description = "IAM bindings managed by this module, as role|member keys."
  value       = sort(keys(google_project_iam_member.this))
}
