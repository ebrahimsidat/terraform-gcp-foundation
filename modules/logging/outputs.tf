output "bucket_id" {
  description = "Fully qualified ID of the audit log bucket."
  value       = google_logging_project_bucket_config.audit.id
}

output "sink_writer_identity" {
  description = "Service account identity used by the log sink."
  value       = google_logging_project_sink.audit.writer_identity
}
