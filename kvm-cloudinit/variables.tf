variable "libvirt_uri" {
  type    = string
  default = "qemu:///system"
}

variable "vm_base_image_uri" {
  type = string
}

variable "virtual_bridge" {
  type    = string
  default = "br0"

}

variable "gateway" {
  type = string
}

variable "nameservers" {
  type    = string
  default = "[\"8.8.8.8\", \"8.8.4.4\"]"
}

variable "cloud_init_cfg_path" {
  type    = string
  default = "cloud_init.cfg"
}

variable "vms" {
  type = list(
    object({
      name        = string
      vcpu        = number
      memory      = number
      disk        = number
      ip          = string
      mac         = string
      description = string
      volumes = list(
        object({
          name = string
          disk = number
        })
      )
    })
  )
}
