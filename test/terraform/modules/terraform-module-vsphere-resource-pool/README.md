Usage Example:
```
module "resource_pool" {
  source             = "./modules/vsphere_resource_pool"
  datacenter         = "${var.datacenter}"
  compute_cluster    = "cc01"
  resource_pool_name = "${var.resource_pool_name}"
}
```