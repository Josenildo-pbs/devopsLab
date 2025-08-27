terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.44"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
  }
}

# Google provider (creates GKE, VPC, etc.)
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Read the cluster that this same config creates
data "google_container_cluster" "this" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id
}

# Get an OAuth2 access token from your gcloud/SA auth
data "google_client_config" "default" {}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.this.endpoint}"
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.this.master_auth[0].cluster_ca_certificate
  )
  token = data.google_client_config.default.access_token
}