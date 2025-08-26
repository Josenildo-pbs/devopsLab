variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "southamerica-east1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "southamerica-east1-b"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "dev-gke"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "dev-vpc"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "dev-subnet"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.10.0.0/24"
}

variable "ip_range_pods" {
  description = "Secondary range for Pods (VPC-native)"
  type        = string
  default     = "10.20.0.0/16"
}

variable "ip_range_services" {
  description = "Secondary range for Services (VPC-native)"
  type        = string
  default     = "10.30.0.0/20"
}

variable "node_count" {
  description = "Default node count"
  type        = number
  default     = 2
}

variable "node_machine_type" {
  description = "Machine type for node pool"
  type        = string
  default     = "e2-standard-2"
}
