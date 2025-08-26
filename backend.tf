terraform {
  backend "gcs" {
    bucket  = "tfstate-mentoring"
    prefix  = "infra"
  }
}