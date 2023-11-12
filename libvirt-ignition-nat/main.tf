data "template_file" "ignition_file" {
  count    = length(var.vms)
  template = file(var.vms[count.index].ignition_file)
}

resource "libvirt_ignition" "ignition" {
  count   = length(var.vms)
  name    = "${var.vms[count.index].name}.ign"
  content = data.template_file.ignition_file[count.index].rendered
}

locals {
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
    hostname     = var.vms[count.index].name
    addresses    = [var.vms[count.index].ip]
    mac          = var.vms[count.index].mac
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
  name           = "${var.vms[count.index].name}.qcow2"
  pool           = "default"
  format         = "qcow2"
  base_volume_id = var.vm_base_image_uri
  size           = var.vms[count.index].disk
}
