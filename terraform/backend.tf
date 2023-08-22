
resource "google_storage_bucket" "tfstate" {
 name          = var.bucket_tfstate
 location      = "US"
 storage_class = "STANDARD"
 project       = var.project_id


 uniform_bucket_level_access = true
}


terraform {
  backend "gcs" {
    prefix  = "terraform/state"
  }
}