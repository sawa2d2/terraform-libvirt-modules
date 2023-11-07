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

variable "dns_hosts" {
  type = list(
    object({
      hostname = string
      ip       = string
    })
  )
}

variable "domain" {
  type = string
}

variable "bridge_name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "nameservers" {
  type = list(string)
}

variable "dnsmasq_options" {
  type = list(
    object({
      option_name  = string
      option_value = string
    })
  )
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
