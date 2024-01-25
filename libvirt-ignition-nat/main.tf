resource "libvirt_ignition" "ignition" {
  count   = length(var.vms)
  name    = "${var.vms[count.index].name}.ign"
  content = templatefile(var.vms[count.index].ignition_file, {})
  #pool    = var.pool
  # The error https://github.com/dmacvicar/terraform-provider-libvirt/issues/978 may occur
  # for some reason when changing pool location, so keep as default, not `var.pool`.
  pool = "default"
}

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

  volume_list      = { for vm in var.vms : "${vm.name}" => flatten([for volume in vm.volumes : volume]) }
  volume_name_list = [for vm, volumes in local.volume_list : [for volume in volumes : { "name" : "${vm}_${volume.name}", "disk" : volume.disk }]]
  volumes          = flatten(local.volume_name_list)
  volumes_indexed  = { for index, volume in local.volumes : volume.name => index }
}

resource "libvirt_domain" "vm" {
  count  = length(var.vms)
  name   = var.vms[count.index].name
  vcpu   = var.vms[count.index].vcpu
  memory = var.vms[count.index].memory

  disk {
    volume_id = libvirt_volume.system[count.index].id
    scsi      = "true"
  }
  dynamic "disk" {
    for_each = local.volume_list[var.vms[count.index].name]
    content {
      volume_id = libvirt_volume.volume[lookup(local.volumes_indexed, "${var.vms[count.index].name}_${disk.value.name}")].id
      scsi      = "true"
    }
  }

  coreos_ignition = libvirt_ignition.ignition[count.index].id
  autostart       = true

  network_interface {
    network_name = var.network_name
    addresses    = [var.vms[count.index].ip]
    mac          = local.mac_addrs[count.index]
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  # Makes the tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
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

resource "libvirt_volume" "volume" {
  count  = length(local.volumes)
  name   = "${local.volumes[count.index].name}.qcow2"
  pool   = var.pool
  format = "qcow2"
  size   = local.volumes[count.index].disk
}
 