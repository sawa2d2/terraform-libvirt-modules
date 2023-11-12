variable "libvirt_uri" {
  type    = string
  default = "qemu:///system"
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
  default = []
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
  default = []
}
