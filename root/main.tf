locals {
  ce_sa = {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}



module "example-it" {
  source               = "app.terraform.io/sr-test-org/vm-instance-template/gcp"
  version              = "0.0.1"
  name_prefix          = "example-it"
  service_account      = local.ce_sa
  project_id           = var.project_id
  source_image_project = var.source_image_project
  source_image         = var.source_image
  region               = var.region
  subnetwork           = var.subnetwork
  subnetwork_project   = var.subnetwork_project
  depends_on           = [google_project_iam_member.tfc_sa_role_binding]
}

module "example-mig" {
  source              = "app.terraform.io/sr-test-org/vm-managed-instance-group/gcp"
  version             = "0.0.1"
  hostname            = "example-mig"
  project_id          = var.project_id
  region              = var.region
  instance_template   = module.example-it.self_link
  autoscaling_enabled = false
  max_replicas        = 1
  min_replicas        = 1
  autoscaling_cpu     = [{ target = 0.6, predictive_method = "NONE" }]
  named_ports = [
    {
      port = 80
      name = "http"
    }]
}

module "hc" {
  source              = "app.terraform.io/sr-test-org/vm-health-check/gcp"
  version             = "0.0.1"
  project = var.project_id
  region  = var.region
  health_checks = [{
    name               = "tcp-hc"
    protocol           = "TCP"
    port               = 80
    check_interval_sec = 10
  }]
}

module "network-internal-lb" {
  source              = "app.terraform.io/sr-test-org/regional-passthrough-lb/gcp"
  version             = "0.0.1"
  project               = var.project_id
  network               = var.network
  subnetwork            = var.subnetwork
  network_project       = var.subnetwork_project
  global_access         = true
  name                  = "example-nlb-internal"
  load_balancing_scheme = "internal"

  health_checks = [module.hc.health_checks["tcp-hc"]]

  ports                        = ["80"]
  create_backend_firewall      = true
  create_health_check_firewall = true

  source_tags = []
  target_tags = ["target-server"]
  backends = [
    { group = module.example-mig.instance_group, description = "mig desription", failover = false },
  ]
}