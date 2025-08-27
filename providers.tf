# providers.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.44"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

data "google_client_config" "default" {}

data "google_container_cluster" "this" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.this.endpoint}"
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.this.master_auth[0].cluster_ca_certificate
  )
  token = data.google_client_config.default.access_token
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.this.endpoint}"
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.this.master_auth[0].cluster_ca_certificate
    )
    token = data.google_client_config.default.access_token
  }
}
