# ------------------- vSphere -------------------
vsphere_datacenter               = "Datacenter"
vsphere_compute_cluster          = "Cluster"
vsphere_datastore_cluster        = "NAS"
vsphere_network                  = "VM Network"
# -----------------------------------------------

# ------- Virtual Machine Template Setup --------
project_name = "phoenix"
vms = {
  masterr01 = {
    hostname = "vm004011"
    ipaddr   = "172.16.4.11"
    cpu      = 4
    memory   = 4096
  },
  masterr02 = {
    hostname = "vm004012"
    ipaddr   = "172.16.4.12"
    cpu      = 4
    memory   = 4096
  },
  masterr03 = {
    hostname = "vm004013"
    ipaddr   = "172.16.4.13"
    cpu      = 4
    memory   = 4096
  },
  worker01 = {
    hostname = "vm004014"
    ipaddr   = "172.16.4.14"
    cpu      = 8
    memory   = 8192
  },
  worker02 = {
    hostname = "vm004015"
    ipaddr   = "172.16.4.15"
    cpu      = 8
    memory   = 8192
  },
  worker03 = {
    hostname = "vm004016"
    ipaddr   = "172.16.4.16"
    cpu      = 8
    memory   = 8192
  }
}
gateway      = "172.16.1.1"
ipv4_netmask = "16"
dns          = ["172.16.1.1"]
# -----------------------------------------------