variable "name" {
  type = "string"
}

variable "datacenter" {
  type = "string"
}

variable "datastore_cluster" {
  type = "string"
}

variable "virtual_machine_template" {
  type = "string"
}

variable "num_cpus" {
  type = "string"
}

variable "memory" {
  type = "string"
}

variable "hostname" {
  type = "string"
}

variable "gateway" {
  type = "string"
}

variable "ipv4_address" {
  type = "string"
}

variable "ipv4_netmask" {
  type = "string"
}

variable "dns_server_list" {
  type = "list"
}

variable "vsphere_network" {
  type = "string"
}

variable "resource_pool_id" {
  type = "string"
}

variable "ssh_username" {
  type = "string"
}

variable "ssh_password" {
  type = "string"
}

#variable "remote_exec" {
#  type = "list"
#}

