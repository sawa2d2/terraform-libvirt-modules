# Localhost: "qemu:///system"
# Remote   : "qemu+ssh://<user>@<host>/system"
libvirt_uri = "qemu:///system"

### Base image URI for VM ###
# Download the image from:
#   $ curl -LO https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/38.20231002.3.1/x86_64/fedora-coreos-38.20231002.3.1-qemu.x86_64.qcow2.xz
#   $ xz -dv *.qcow2.xz
vm_base_image_uri = "/var/lib/libvirt/images/fedora-coreos-38.20231002.3.1-qemu.x86_64.qcow2"

# Optional:
#pool = "default"

bridge = "br0"

vms = [
  {
    name          = "coreos"
    vcpu          = 4
    memory        = 16000                    # in MiB
    disk          = 100 * 1024 * 1024 * 1024 # 100 GB
    ip            = "192.168.8.210"
    ignition_file = "ignition.ign"
    volumes       = []
  }
]
