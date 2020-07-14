resource "vsphere_virtual_machine" "vm" {
  name                 = "${var.name}"
  resource_pool_id     = "${var.resource_pool_id}"
  datastore_cluster_id = "${data.vsphere_datastore_cluster.datastore_cluster.id}"
  num_cpus             = "${var.num_cpus}"
  memory               = "${var.memory}"
  firmware             = "${data.vsphere_virtual_machine.template.firmware}"
  guest_id             = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type            = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        domain    = ""
        host_name = "${var.hostname}"
      }

      ipv4_gateway    = "${var.gateway}"
      dns_server_list = "${var.dns_server_list}"

      network_interface {
        ipv4_address = "${var.ipv4_address}"
        ipv4_netmask = "${var.ipv4_netmask}"
      }
    }
  }

  # provisioner "file" {
  #   connection {
  #     type     = "ssh"
  #     user     = "${var.ssh_username}"
  #     password = "${var.ssh_password}"
  #     timeout  = "1m"
  #   }

  #   source      = "conf/"
  #   destination = "/usr/local/src/"
  # }

  # provisioner "remote-exec" {
  #   connection {
  #     type     = "ssh"
  #     user     = "${var.ssh_username}"
  #     password = "${var.ssh_password}"
  #     timeout  = "10m"
  #   }

  #   inline = "${var.remote_exec}"
  # }
}
