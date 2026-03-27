
variable "zone" {
  description = "Scaleway zone name"
  type        = string
}

variable "vms" {
  description = "Amount of VMs to create"
  type        = number
  default     = 0
}

variable "name" {
  description = "Name of the VM"
  type        = string
  default     = "group-1"
}

variable "description" {
  description = "Description"
  type        = string
  default     = ""
}

variable "pool" {
  description = "Name of the VM pool"
  type        = string
  default     = ""
}

variable "type" {
  description = "Type for the VM"
  type        = string
}

variable "boot_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 32
}

variable "template_id" {
  description = "ID of the template VM"
  type        = string
}

variable "firewall_id" {
  description = "ID of the firewall"
  type        = string
  default     = ""
}

variable "placement_group_id" {
  description = "ID of the placement group"
  type        = string
  default     = ""
}

variable "network" {
  type = map(any)
  default = {
    "public" = {
      ip6 = true
      ip4 = true
    }
    # "private" = {
    #   ip6        = ""
    #   ip4network = 1234
    #   ip6subnet  = "fd60:172:16::/64"
    #   ip6mask    = 64
    #   ip6index   = 512
    #   ip4        = ""
    #   ip4network = 1234
    #   ip4subnet  = "192.168.0.0/28"
    #   ip4mask    = 24
    #   ip4index   = 30
    # }
  }
}

variable "cloudinit_userdata" {
  description = "Userdata for cloud-init image"
  type        = string
  sensitive   = true
  default     = ""
}

variable "tags" {
  description = "Tags to be applied to the VM"
  type        = list(string)
  default     = []
}
