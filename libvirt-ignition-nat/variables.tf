variable "libvirt_uri" {
  type    = string
  default = "qemu:///system"
}

variable "vm_base_image_uri" {
  type = string
}

variable "network_name" {
  type = string
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
      mac           = string
      ignition_file = string
      description   = string
      volumes = list(
        object({
          name = string
          disk = number
        })
      )
    })
  )
}
