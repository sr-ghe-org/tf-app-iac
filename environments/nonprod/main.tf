module "app1_it" {
    source = "../../root"
    name_prefix=var.name_prefix
    project_id=var.project_id
    source_image_project=var.source_image_project
    source_image=var.source_image
    region=var.region
    network=var.network
    subnetwork=var.subnetwork
    subnetwork_project=var.subnetwork_project
    tfc_sa_name = var.tfc_sa_name
}