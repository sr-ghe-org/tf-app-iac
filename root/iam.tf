locals {
  tfc_sa_roles = "roles/editor"
}
resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_project_iam_member" "logs_writer" {
  project = var.project_id
  role = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "tfc_sa_role_binding" {
  project = var.project_id
  role    = local.tfc_sa_roles
  member  = "serviceAccount:${var.tfc_sa_name}@${var.project_id}.iam.gserviceaccount.com"
}