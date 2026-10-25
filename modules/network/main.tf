locals {
  regions = toset([for s in values(var.subnets) : s.region])

  # Google's published source range for Identity-Aware Proxy TCP forwarding.
  iap_source_range = "35.235.240.0/20"
}

resource "google_compute_network" "this" {
  project                         = var.project_id
  name                            = var.network_name
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "this" {
  for_each = var.subnets

  project                  = var.project_id
  name                     = each.key
  region                   = each.value.region
  network                  = google_compute_network.this.id
  ip_cidr_range            = each.value.ip_cidr_range
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ranges

    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = var.flow_log_sampling
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "this" {
  for_each = var.enable_cloud_nat ? local.regions : toset([])

  project = var.project_id
  name    = "${var.network_name}-${each.key}-router"
  region  = each.key
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "this" {
  for_each = google_compute_router.this

  project                            = var.project_id
  name                               = "${var.network_name}-${each.key}-nat"
  router                             = each.value.name
  region                             = each.key
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Explicit, logged default-deny for ingress. GCP denies ingress implicitly, but an explicit rule
# makes the posture visible in reviews and records denied traffic in the logs.
resource "google_compute_firewall" "deny_all_ingress" {
  project     = var.project_id
  name        = "${var.network_name}-deny-all-ingress"
  network     = google_compute_network.this.id
  description = "Default deny for all ingress traffic, with logging."
  direction   = "INGRESS"
  priority    = 65534

  source_ranges = ["0.0.0.0/0"]

  deny {
    protocol = "all"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow_iap_ssh" {
  count = length(var.iap_ssh_target_tags) > 0 ? 1 : 0

  project     = var.project_id
  name        = "${var.network_name}-allow-iap-ssh"
  network     = google_compute_network.this.id
  description = "Allow SSH only from Identity-Aware Proxy to tagged instances."
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = [local.iap_source_range]
  target_tags   = var.iap_ssh_target_tags

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
