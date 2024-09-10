locals {
  ce_sa = {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script =  <<EOF
    sudo yum install -y nfs-utils
    sudo mkdir ${module.gcnv.storage_volumes.mount_options[0].export}
    sudo mount -t nfs -o rw,hard,rsize=65536,wsize=65536,vers=3,tcp ${module.gcnv.storage_volumes.mount_options[0].export_full} ${module.gcnv.storage_volumes.mount_options[0].export}
  EOF
}



module "example-it" {
  source               = "app.terraform.io/sr-test-org/vm-instance-template/gcp"
  version              = "0.0.2"
  name_prefix          = "example-it"
  service_account      = local.ce_sa
  project_id           = var.project_id
  source_image_project = var.source_image_project
  source_image         = var.source_image
  startup_script       = local.metadata_startup_script
  region               = var.region
  subnetwork           = var.subnetwork
  subnetwork_project   = var.subnetwork_project
  depends_on           = [google_project_iam_member.tfc_sa_role_binding]
}
