variable "libvirt_uri" {
  type    = string
  default = "qemu:///system"
}

variable "vm_base_image_uri" {
  type = string
}

variable "bridge" {
  type    = string
  default = "br0"
}

variable "cidr" {
  type    = string
  default = "192.168.0.0/24"
}

variable "gateway" {
  type = string
}

variable "nameservers" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.4.4"]
}

variable "pool" {
  type    = string
  default = "default"
}

variable "vms" {
  type = list(
    object({
      name           = string
      vcpu           = number
      memory         = number
      disk           = number
      ip             = string
      mac            = string
      cloudinit_file = string
      description    = string
      volumes = list(
        object({
          name = string
          disk = number
        })
      )
    })
  )
}
