/*
data "google_compute_network" "network" {
  name    = var.network
  project = var.subnetwork_project
}

resource "google_netapp_storage_pool" "default" {
  project = var.project_id
  name = "test-pool"
  location = "us-central1"
  service_level = "PREMIUM"
  capacity_gib = "2048"
  network = data.google_compute_network.network.id
}

resource "google_netapp_volume" "test_volume" {
  project = var.project_id
  location = "us-central1"
  name = "test-volume"
  capacity_gib = "100"
  share_name = "test-volume"
  storage_pool = google_netapp_storage_pool.default.name
  protocols = ["NFSV3"]
  deletion_policy = "DEFAULT"
  export_policy {
    rules {
      allowed_clients = "0.0.0.0/0"
      has_root_access = true
      access_type = "READ_WRITE"
      nfsv3 = true
      #nfsv4 = true
    }
  }
}
*/

module "gcnv" {
  source              = "app.terraform.io/sr-test-org/netapp-volumes/gcp"
  version             = "0.0.1"
  project = var.project_id
  location  = var.region

  storage_pool = {
    create_pool   = true
    name          = "test-pool"
    size          = "2048"
    service_level = "PREMIUM"
    ldap_enabled  = false
    network_name  = var.network
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