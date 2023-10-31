terraform {
  backend "gcs" {
    prefix = "terraform/poc-gke-gcp-bootstrap"
  }
}