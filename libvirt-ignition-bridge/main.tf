locals {
  # Auto-calculate mac address from IP 
  ips_parts = [for vm in var.vms : split(".", vm.ip)]
  mac_addrs = [
    for ip_parts in local.ips_parts : format(
      "52:54:00:%02X:%02X:%02X",
      tonumber(ip_parts[1]),
      tonumber(ip_parts[2]),
      tonumber(ip_parts[3])
    )
  ]
}

resource "libvirt_ignition" "ignition" {
  count   = length(var.vms)
  name    = "${var.vms[count.index].name}.ign"
  content = templatefile(var.vms[count.index].ignition_file, {})
  pool    = var.pool
}

resource "libvirt_domain" "vm" {
  count  = length(var.vms)
  name   = var.vms[count.index].name
  vcpu   = var.vms[count.index].vcpu
  memory = var.vms[count.index].memory

  disk {
    volume_id = libvirt_volume.system[count.index].id
  }
  coreos_ignition = libvirt_ignition.ignition[count.index].id
  autostart       = true

  network_interface {
    bridge    = var.bridge
    addresses = [var.vms[count.index].ip]
    mac       = local.mac_addrs[count.index]
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}

resource "libvirt_volume" "system" {
  count          = length(var.vms)
  name           = "${var.vms[count.index].name}.qcow2"
  pool           = var.pool
  format         = "qcow2"
  base_volume_id = var.vm_base_image_uri
  size           = var.vms[count.index].disk
}
