provider "google" {
  credentials = "${file("projet-cluster-14b515b50cae.json")}"
  project = "projet-cluster"
  region = "europe-west2"
}

############################## reseau ########################################

resource "google_compute_network" "test" {
  name                    = "network-test"
  auto_create_subnetworks = false
}

############################## sous reseau1 ########################################

resource "google_compute_subnetwork" "sr1" {
  name          = "subnetwork-test1"
  #premier intervalle ip
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-west2"
  network       = "${google_compute_network.test.name}"

}

############################## sous reseau2 ########################################

resource "google_compute_subnetwork" "sr2" {
  name          = "subnetwork-test2"
  #deuxieme intervalle ip
  ip_cidr_range = "192.168.0.0/26"
  region        = "europe-west2"
  network       = "${google_compute_network.test.name}"
  secondary_ip_range {
    range_name    = "secondary-range"
    ip_cidr_range = "192.168.10.0/24"
  }
}

############################## firewall 80 et 22 ########################################

resource "google_compute_firewall" "http" {
  name = "http"
  network = "${google_compute_network.test.name}"
   source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

}

resource "google_compute_firewall" "ssh" {
  name = "ssh"
  network = "${google_compute_network.test.name}"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}

#################################### mon cluster ############################################

resource "google_container_cluster" "master" {
  name = "my-cluster"
  location = "europe-west2-b"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "${google_compute_subnetwork.sr1.ip_cidr_range}"
    }
  }

  ip_allocation_policy {
    node_ipv4_cidr_block = "192.168.0.0/26"

  }



  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "node1" {
  name       = "my-node1"
  location   = "europe-west2-b"
  cluster    = "${google_container_cluster.master.name}"
  node_count = 2


  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata {
      disable-legacy-endpoints = "true"
      type = "stateful"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}


output "client_certificate" {
  value = "${google_container_cluster.master.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.master.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.master.master_auth.0.cluster_ca_certificate}"
}



#################################################################################################
#                                                                                               #
#                                                                                               #
#                                      machine virtuelle                                        #
#                                                                                               #
#                                                                                               #
#################################################################################################



resource "google_compute_instance" "mongodb" {
  name         = "centos"
  machine_type = "n1-standard-1"
  zone         = "europe-west2-b"



  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"

    }
  }



  network_interface {
    network       = "${google_compute_network.test.name}"
    subnetwork = "${google_compute_subnetwork.sr1.name}"
  access_config {

  }
  }

  tags = ["user01"]

  metadata {
sshKeys="user01:${file("~/.ssh/id_rsa.pub")}"

  }


}
