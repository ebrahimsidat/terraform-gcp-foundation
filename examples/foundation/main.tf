module "services" {
  source = "../../modules/project-services"

  project_id = var.project_id

  services = [
    "compute.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ]
}

module "network" {
  source = "../../modules/network"

  project_id   = var.project_id
  network_name = var.network_name
  subnets      = var.subnets

  depends_on = [module.services]
}

module "logging" {
  source = "../../modules/logging"

  project_id     = var.project_id
  location       = var.region
  retention_days = 400

  depends_on = [module.services]
}

module "iam" {
  source = "../../modules/iam"

  project_id   = var.project_id
  role_members = var.role_members
}
