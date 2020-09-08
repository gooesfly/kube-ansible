# ------------------- vSphere -------------------
variable "vsphere_server" {
  description = "vsphere server url"
  type        = string
}

variable "vsphere_user" {
  description = "login vsphere server username"
  type        = string
}

variable "vsphere_password" {
  description = "login vsphere server password"
  type        = string
}

variable "vsphere_datacenter" {
  description = "vsphere datacenter name"
  type        = string
}

variable "vsphere_network" {
  description = "virtual machine network name"
  type        = string
  default     = "VM Network"
}

variable "vsphere_datastore_cluster" {
  description = "datastore cluster name"
  type        = string
}

# -----------------------------------------------

# --------------- Template Setup ----------------
variable "vsphere_virtual_machine_template" {
  type = string
}

variable "project_name" {
  type = string
}


variable "dns" {
  type = list
}

variable "vms" {
  type = map(object({
    hostname = string
    ipaddr   = string
    cpu      = number
    memory   = number
  }))
}

variable "ipv4_netmask" {
  type = string
}

variable "gateway" {
  type = string
}


variable "vsphere_compute_cluster" {
  type = string
}