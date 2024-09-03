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
  network              = var.network
  subnetwork           = var.subnetwork
  subnetwork_project   = var.subnetwork_project
  depends_on           = [google_project_iam_member.tfc_sa_role_binding]
}

module "example-mig" {
  source              = "../../terraform-gcp-vm-managed-instance-group"
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