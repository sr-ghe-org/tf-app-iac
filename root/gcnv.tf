module "gcnv" {
  source     = "app.terraform.io/sr-test-org/netapp-volumes/gcp"
  version    = "0.0.1"
  project_id = var.project_id
  location   = var.region

  storage_pool = {
    create_pool        = true
    name               = "test-pool"
    size               = "2048"
    service_level      = "PREMIUM"
    ldap_enabled       = false
    network_name       = var.network
    network_project_id = var.subnetwork_project
    labels = {
      pool_env = "test"
    }
    description = "test pool"
  }

  storage_volumes = [
    {
      name            = "test-volume"
      share_name      = "test-volume"
      size            = "100"
      protocols       = ["NFSV3"]
      deletion_policy = "FORCE"
      export_policy_rules = {
        test = {
          allowed_clients = "0.0.0.0/0"
          access_type     = "READ_WRITE"
          nfsv3           = true
          has_root_access = true
        }
      }
  }]
}