module "resource_pool" {
  source             = "./modules/terraform-module-vsphere-resource-pool"
  datacenter         = "${var.vsphere_datacenter}"
  compute_cluster    = "Cluster"
  resource_pool_name = "kube-ansible"
}
