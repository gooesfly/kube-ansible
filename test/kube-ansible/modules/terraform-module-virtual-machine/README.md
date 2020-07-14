Usage Example:
```
module "vm-1" {
  source                   = "./modules/vsphere_virtual_machine"
  name                     = "kube-node-0"
  datacenter               = "${var.datacenter}"
  datastore_cluster        = "dsc_12_1"
  virtual_machine_template = "CentOS-7.6"
  num_cpus                 = "2"
  memory                   = "2048"
  hostname                 = "kube-node-0"
  gateway                  = "172.16.1.1"
  ipv4_address             = "172.16.100.11"
  ipv4_netmask             = "16"
  dns_server_list          = "${var.dns_server_list}"
  vsphere_network          = "dmz:100"
  resource_pool_id         = "${module.resource_pool_cc01.resource_pool_id}"
  ssh_username             = "${var.ssh_username}"
  ssh_password             = "${var.ssh_password}"

  remote_exec = [
    "yum install ansible -y",
    "ansible-playbook /usr/local/src/playbook/deploy.yaml -t setup,ntp,salt-minion -e SALT_MASTER_IP=${var.salt_master_ip} -e NODE_ROLES=salt,ca | tee /var/log/playbook.log",
  ]
}
```