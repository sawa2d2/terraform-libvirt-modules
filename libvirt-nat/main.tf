resource "libvirt_network" "network" {
  name      = var.network_name
  mode      = "nat"
  domain    = var.domain
  bridge    = var.bridge_name
  addresses = [var.cidr]
  autostart = true

  dns {
    local_only = true
    dynamic "hosts" {
      for_each = var.dns_hosts
      content {
        hostname = hosts.value.hostname
        ip       = hosts.value.ip
      }
    }
  }

  dnsmasq_options {
    dynamic "options" {
      for_each = var.dnsmasq_options
      content {
        option_name  = options.value["option_name"]
        option_value = options.value["option_value"]
      }
    }
  }
}
