output "network_id" {
  description = "ID of the VPC network."
  value       = google_compute_network.this.id
}

output "network_self_link" {
  description = "Self link of the VPC network."
  value       = google_compute_network.this.self_link
}

output "subnets" {
  description = "Created subnets keyed by name, with region, CIDR range and self link."

  value = {
    for name, subnet in google_compute_subnetwork.this : name => {
      region        = subnet.region
      ip_cidr_range = subnet.ip_cidr_range
      self_link     = subnet.self_link
    }
  }
}

output "nat_names" {
  description = "Cloud NAT gateway names keyed by region."
  value       = { for region, nat in google_compute_router_nat.this : region => nat.name }
}
