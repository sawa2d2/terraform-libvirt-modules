data "template_file" "user_data" {
  template = file(var.cloud_init_cfg_path)
}

data "template_file" "network_config" {
  count    = length(var.vms)
  template = file("${path.module}/network_config.cfg")
  vars = {
    ip          = var.vms[count.index].ip
    gateway     = var.gateway
    nameservers = var.nameservers
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count          = length(var.vms)
  name           = "commoninit_${var.vms[count.index].name}.iso"
  user_data      = data.template_file.user_data.rendered
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
    bridge    = var.virtual_bridge
  }
  qemu_agent = true

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
  name           = "${var.vms[count.index].name}_system.qcow2"
  pool           = "default"
  format         = "qcow2"
  base_volume_id = var.vm_base_image_uri
  size           = var.vms[count.index].disk
}

resource "libvirt_volume" "volume" {
  count  = length(local.volumes)
  name   = "${local.volumes[count.index].name}.qcow2"
  pool   = "default"
  format = "qcow2"
  size   = local.volumes[count.index].disk
}
