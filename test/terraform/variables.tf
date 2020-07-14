# ------------------- vSphere -------------------
variable "vsphere_server" {
  description = "vsphere server url"
  type        = "string"
}

variable "vsphere_user" {
  description = "login vsphere server username"
  type        = "string"
}

variable "vsphere_password" {
  description = "login vsphere server password"
  type        = "string"
}

variable "vsphere_datacenter" {
  description = "vsphere datacenter name"
  type        = "string"
}

variable "vsphere_network" {
  description = "virtual machine network name"
  type        = "string"
  default     = "VM Network"
}

variable "datastore_cluster" {
  description = "datastore cluster name"
  type        = "string"
}

# -----------------------------------------------

# --------------- Template Setup ----------------
variable "vsphere_virtual_machine_template" {
  type = "string"
}

variable "ssh_username" {
  type = "string"
}

variable "ssh_password" {
  type = "string"
}
