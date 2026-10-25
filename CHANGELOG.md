# Changelog

All notable changes to this project are documented in this file.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-25

### Added

- network module: custom-mode VPC, subnets with Private Google Access and flow logs, Cloud Router and Cloud NAT, logged default-deny and IAP-only SSH firewall rules
- logging module: central audit log bucket, log sink and Data Access audit logs
- iam module: additive, validated IAM bindings with roles/owner blocked
- project-services module: API enablement without disable-on-destroy
- Complete foundation example with documented variables
- CI pipeline: terraform fmt, validate for every module, tflint and Checkov
