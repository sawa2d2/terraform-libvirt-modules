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

variable "pool" {
  type    = string
  default = "default"
}

variable "vms" {
  type = list(
    object({
      name          = string
      vcpu          = number
      memory        = number
      disk          = number
      ip            = string
      ignition_file = string
      volumes = list(
        object({
          name = string
          disk = number
        })
      )
    })
  )
}
