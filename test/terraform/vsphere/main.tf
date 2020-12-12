#===============================================================================
# vSphere Backend
#===============================================================================
terraform {
  backend "s3" {
    region                      = "minio"
    force_path_style            = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    # skip_requesting_account_id  = true
    # skip_get_ec2_platforms      = true
  }
}


#===============================================================================
# vSphere Provider
#===============================================================================
provider "vsphere" {
  version              = "~> 1.12"
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}


#===============================================================================
# vSphere Data
#===============================================================================
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


#===============================================================================
# vSphere Resources
#===============================================================================
resource "vsphere_resource_pool" "resource_pool" {
  name                    = var.project_name
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}

resource "vsphere_virtual_machine" "kubernetes" {
  for_each             = var.vms
  name                 = each.value["hostname"]
  resource_pool_id     = vsphere_resource_pool.resource_pool.id
  datastore_cluster_id = data.vsphere_datastore_cluster.vsphere_datastore_cluster.id
  num_cpus             = each.value["cpu"]
  memory               = each.value["memory"]
  firmware             = data.vsphere_virtual_machine.template.firmware
  guest_id             = data.vsphere_virtual_machine.template.guest_id
  scsi_type            = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        domain    = ""
        host_name = each.value["hostname"]
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns

      network_interface {
        ipv4_address = each.value["ipaddr"]
        ipv4_netmask = var.ipv4_netmask
      }
    }
  }
}

