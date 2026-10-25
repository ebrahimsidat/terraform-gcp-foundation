# Design notes

## Custom-mode VPC

Auto-mode networks create a subnet in every region with predictable ranges, which overlap with on-premises
and other VPCs and widen the attack surface. The `network` module always creates a custom-mode VPC
(`auto_create_subnetworks = false`) and only the subnets that are declared.

## Private by default

- **Private Google Access** is enabled on every subnet, so instances without external IPs can still reach
  Google APIs.
- **Cloud NAT** is created per region that hosts a subnet, giving outbound internet access without
  public IPs. NAT logging is set to `ERRORS_ONLY` to keep log volume and cost predictable.
- **SSH is only allowed from Identity-Aware Proxy** (`35.235.240.0/20`) to instances carrying an explicit
  network tag. Access is then governed by IAM (`roles/iap.tunnelResourceAccessor`) and fully audited.

## Explicit, logged default-deny

Google Cloud already denies ingress implicitly, but implicit rules cannot be logged. An explicit deny-all rule
at priority 65534 records denied connection attempts, which helps both incident investigation and audits.

## Additive IAM

The `iam` module uses `google_project_iam_member`, which adds individual bindings instead of replacing the
project's policy. This lets several teams or pipelines manage their own access safely and prevents Terraform
from removing bindings it does not own. Granting `roles/owner` through the module is blocked by validation.

## Centralised audit logging

All Cloud Audit Logs and VPC firewall logs are routed to a dedicated log bucket with a defined retention period
(400 days by default, covering a full annual audit cycle). Data Access audit logs are enabled for all services
because they are disabled by default in Google Cloud and are often required by security policies.

## Provider version policy

Modules accept Google provider versions `>= 6.0, < 8.0`. Root configurations should pin an exact minor version
and commit `.terraform.lock.hcl`, so that upgrades happen deliberately through reviewed changes.
