variable "project_id" { 
type = string 
default = "avid-indexer-105420"
}
variable "region"     {
 type = string
default = "us-central1" 
}
variable "zone"       {
 type = string
default = "us-central1-b" 
}
variable "cluster_name" {
 type = string
default = "cpu-stress-cluster" 
}
variable "node_count" {
 type = number
default = 1 
}
variable "node_machine_type" {
 type = string
 default = "e2-standard-2"
}
