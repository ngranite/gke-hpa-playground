resource "google_project_service" "required_apis" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])
  service = each.key
}

# Create a GKE cluster (regional)
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count = 1
  network 		   = "projects/avid-indexer-105420/global/networks/breops-us-zones"
  subnetwork               = "projects/avid-indexer-105420/regions/us-central1/subnetworks/first-subnet"
  node_locations 	   = ["us-central1-b"]
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {}
}

# Create a node pool for the cluster
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 25
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  initial_node_count = var.node_count
}
