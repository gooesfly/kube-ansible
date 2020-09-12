data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore_cluster" "vsphere_datastore_cluster" {
  name          = var.vsphere_datastore_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_virtual_machine_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
