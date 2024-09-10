resource "google_netapp_storage_pool" "default" {
  project = var.project_id
  name = "test-pool"
  location = "us-central1"
  service_level = "PREMIUM"
  capacity_gib = "2048"
  network = var.network
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