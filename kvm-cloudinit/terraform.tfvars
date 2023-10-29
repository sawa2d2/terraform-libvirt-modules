# Localhost: "qemu:///system"
# Remote   : "qemu+ssh://<user>@<host>/system"
libvirt_uri = "qemu:///system"

### Base image URI for VM ###
# Download the image by:
#   sudo curl -L -o /var/lib/libvirt/images/Rocky-9-GenericCloud.latest.x86_64.qcow2 https://download.rockylinux.org/pub/rocky/9.2/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2 
vm_base_image_uri = "/var/lib/libvirt/images/Rocky-9-GenericCloud.latest.x86_64.qcow2"

# Networking
virtual_bridge = "br0"

gateway     = "192.168.8.1"
nameservers = "[\"192.168.8.1\"]"

vms = [
  {
    name        = "vm1"
    vcpu        = 4
    memory      = 16000                    # in MiB
    disk        = 100 * 1024 * 1024 * 1024 # 100 GB
    ip          = "192.168.8.200/24"
    mac         = "52:54:00:00:00:00"
    description = ""
    volumes = [
      {
        name = "vdb"
        disk = 1024 * 1024 * 1024 * 1024 # 1 TB 
      },
      {
        name = "vdc"
        disk = 1024 * 1024 * 1024 * 1024 # 1 TB 
      },
    ]
  },
  {
    name        = "vm2"
    vcpu        = 4
    memory      = 16000                    # in MiB
    disk        = 100 * 1024 * 1024 * 1024 # 100 GB
    ip          = "192.168.8.201/24"
    mac         = "52:54:00:00:00:01"
    description = ""
    volumes = [
      {
        name = "vdb"
        disk = 1024 * 1024 * 1024 * 1024 # 1 TB 
      },
    ]
  },
  {
    name        = "vm3"
    vcpu        = 4
    memory      = 16000                    # in MiB
    disk        = 100 * 1024 * 1024 * 1024 # 100 GB
    ip          = "192.168.8.202/24"
    mac         = "52:54:00:00:00:02"
    description = ""
    volumes = [
      {
        name = "vdb"
        disk = 1024 * 1024 * 1024 * 1024 # 1 TB 
      },
      {
        name = "vdc"
        disk = 1024 * 1024 * 1024 * 1024 # 1 TB 
      },
    ]
  },
]