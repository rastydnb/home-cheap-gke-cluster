resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = "false"
  project = var.project_id
  # Everything in this solution is deployed regionally
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "default" {
  depends_on    = [google_compute_network.default]
  name          = "${var.gke_cluster_name}-subnet"
  project       = google_compute_network.default.project
  region        = var.region
  network       = google_compute_network.default.name
  ip_cidr_range = "10.0.0.0/24"
}

# A NAT router is needed for egress from the VPC-native, private GKE cluster. 
# Without this, you would not be able to pull images directly from Docker Hub
# or make external service calls from your applications deployed in the cluster.
# Monthly cost of the NAT gateway is about $1 per VM deployed, so for a 3 nodes cluster 
# it costs about $3 per month. For the convenience, it's worth it.
#
# Alternative to NAT would be to use the Google Cloud Artifact Registry to store your
# container images: https://cloud.google.com/artifact-registry/docs/docker/quickstart

resource "google_compute_router" "router" {
  name    = "nat-router"
  project = google_compute_subnetwork.default.project
  region  = google_compute_subnetwork.default.region
  network = google_compute_network.default.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  project                            = google_compute_router.router.project
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}