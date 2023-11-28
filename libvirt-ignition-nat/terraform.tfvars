# Localhost: "qemu:///system"
# Remote   : "qemu+ssh://<user>@<host>/system"
libvirt_uri = "qemu:///system"

# Download the image from:
#   $ curl -LO https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/38.20231002.3.1/x86_64/fedora-coreos-38.20231002.3.1-qemu.x86_64.qcow2.xz
#   $ xz -dv *.qcow2.xz
#vm_base_image_uri = "/var/lib/libvirt/images/fedora-coreos-38.20231002.3.1-qemu.x86_64.qcow2"
vm_base_image_uri = "/var/lib/libvirt/images/fedora-coreos-38.20230609.3.0-qemu.x86_64.qcow2"

network_name = "default"
vms = [
  {
    name          = "coreos"
    vcpu          = 4
    memory        = 16000                    # in MiB
    disk          = 100 * 1024 * 1024 * 1024 # 100 GB
    ip            = "192.168.122.100"
    ignition_file = "ignition.ign"
    volumes = [
      {
        name = "additional_disk"
        disk = 100 * 1024 * 1024 * 1024 # 100 GB
      }
    ]
  }
]
