module "hc" {
  source  = "app.terraform.io/sr-test-org/vm-health-check/gcp"
  version = "0.0.1"
  project = var.project_id
  region  = var.region
  health_checks = [{
    name               = "tcp-hc"
    protocol           = "TCP"
    port               = 80
    check_interval_sec = 10
  }]
}