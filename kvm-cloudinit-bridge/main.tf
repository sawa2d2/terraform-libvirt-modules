data "template_file" "user_data" {
  count    = length(var.vms)
  template = file(var.vms[count.index].cloudinit_file)
}

data "template_file" "network_config" {
  count    = length(var.vms)
  template = file("${path.module}/network_config.cfg")
  vars = {
    ip          = "${var.vms[count.index].ip}/${var.cidr_prefix}"
    gateway     = var.gateway
    nameservers = var.nameservers
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count          = length(var.vms)
  name           = "commoninit_${var.vms[count.index].name}.iso"
  user_data      = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config[count.index].rendered
}

locals {
  volume_list      = { for vm in var.vms : "${vm.name}" => flatten([for volume in vm.volumes : volume]) }
  volume_name_list = [for vm, volumes in local.volume_list : [for volume in volumes : { "name" : "${vm}_${volume.name}", "disk" : volume.disk }]]
  volumes          = flatten(local.volume_name_list)
  volumes_indexed  = { for index, volume in local.volumes : volume.name => index }
}

resource "libvirt_domain" "vm" {
  count       = length(var.vms)
  description = var.vms[count.index].description

  name   = var.vms[count.index].name
  vcpu   = var.vms[count.index].vcpu
  memory = var.vms[count.index].memory

  disk {
    volume_id = libvirt_volume.system[count.index].id
  }

  dynamic "disk" {
    for_each = local.volume_list[var.vms[count.index].name]
    content {
      volume_id = libvirt_volume.volume[lookup(local.volumes_indexed, "${var.vms[count.index].name}_${disk.value.name}")].id
    }
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
  autostart = true

  network_interface {
    hostname  = var.vms[count.index].name
    addresses = [var.vms[count.index].ip]
    mac       = var.vms[count.index].mac
    bridge    = var.bridge
  }
  qemu_agent = true

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
  name           = "${var.vms[count.index].name}_system.qcow2"
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
