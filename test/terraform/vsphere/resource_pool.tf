resource "vsphere_resource_pool" "resource_pool" {
  name                    = var.project_name
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}
