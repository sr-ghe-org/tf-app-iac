module "network-internal-lb" {
  source              = "app.terraform.io/sr-test-org/regional-passthrough-lb/gcp"
  version             = "0.0.2"
  project               = var.project_id
  network               = var.network
  subnetwork            = var.subnetwork
  network_project       = var.subnetwork_project
  global_access         = true
  name                  = "example-nlb-internal"
  load_balancing_scheme = "internal"

  health_checks = [module.hc.health_checks["tcp-hc"]]

  ports                        = ["80"]
  backends = [
    { group = module.example-mig.instance_group, description = "mig desription", failover = false },
  ]
}