# APIs necessárias
resource "google_project_service" "required" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com"
  ])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# GKE Cluster (VPC-native)
resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region

  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  depends_on = [google_project_service.required]
}

resource "kubernetes_namespace" "tekton" {
  metadata { name = "tekton" }
  depends_on = [google_container_cluster.gke]   # ensure cluster exists first
}

resource "kubernetes_namespace" "application" {
  metadata { name = "application" }
  depends_on = [google_container_cluster.gke]
}


# Node pool gerenciado
resource "google_container_node_pool" "default_pool" {
  name       = "default-pool"
  location   = var.region
  cluster    = google_container_cluster.gke.name

  node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      env = "dev"
    }
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

