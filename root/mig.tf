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