resource "google_logging_project_bucket_config" "audit" {
  project        = var.project_id
  location       = var.location
  bucket_id      = var.bucket_id
  retention_days = var.retention_days
  description    = "Central bucket for audit and security logs."
}

resource "google_logging_project_sink" "audit" {
  project                = var.project_id
  name                   = "${var.bucket_id}-sink"
  destination            = "logging.googleapis.com/${google_logging_project_bucket_config.audit.id}"
  filter                 = var.sink_filter
  unique_writer_identity = true
}

resource "google_project_iam_audit_config" "all_services" {
  count = var.enable_data_access_logs ? 1 : 0

  project = var.project_id
  service = "allServices"

  audit_log_config {
    log_type = "ADMIN_READ"
  }

  audit_log_config {
    log_type = "DATA_READ"
  }

  audit_log_config {
    log_type = "DATA_WRITE"
  }
}
