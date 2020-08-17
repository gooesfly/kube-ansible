module "vm018017" {
  source                   = "./modules/terraform-module-virtual-machine"
  name                     = "vm018017"
  datacenter               = "${var.vsphere_datacenter}"
  datastore_cluster        = "${var.datastore_cluster}"
  virtual_machine_template = "${var.vsphere_virtual_machine_template}"
  num_cpus                 = "4"
  memory                   = "4096"
  hostname                 = "vm018017"
  gateway                  = "172.16.1.1"
  ipv4_address             = "172.16.18.17"
  ipv4_netmask             = "16"

  dns_server_list = [
    "172.16.1.1",
  ]

  vsphere_network  = "${var.vsphere_network}"
  resource_pool_id = "${module.resource_pool.resource_pool_id}"
  ssh_username     = "${var.ssh_username}"
  ssh_password     = "${var.ssh_password}"
}
