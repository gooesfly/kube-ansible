data "vsphere_datacenter" "datacenter" {
  name = "${var.datacenter}"
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "${var.compute_cluster}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}
