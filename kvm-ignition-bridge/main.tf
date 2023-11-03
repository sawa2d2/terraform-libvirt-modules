data "template_file" "ignition_file" {
  count    = length(var.vms)
  template = file(var.vms[count.index].ignition_file)
}

resource "libvirt_ignition" "ignition" {
  count   = length(var.vms)
  name    = "${var.vms[count.index].name}.ign"
  content = data.template_file.ignition_file[count.index].rendered
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
}

resource "libvirt_volume" "system" {
  count          = length(var.vms)
  name           = "${var.vms[count.index].name}.qcow2"
  pool           = "default"
  format         = "qcow2"
  base_volume_id = var.vm_base_image_uri
  size           = var.vms[count.index].disk
}
