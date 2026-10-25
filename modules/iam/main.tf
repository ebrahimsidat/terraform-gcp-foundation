locals {
  # Flatten {role => [members]} into one entry per binding so each can be managed independently.
  bindings = {
    for pair in flatten([
      for role, members in var.role_members : [
        for member in members : { role = role, member = member }
      ]
    ]) : "${pair.role}|${pair.member}" => pair
  }
}

# Additive bindings: existing IAM policy outside this module is left untouched.
resource "google_project_iam_member" "this" {
  for_each = local.bindings

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}
