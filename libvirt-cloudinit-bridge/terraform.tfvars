# Localhost: "qemu:///system"
# Remote   : "qemu+ssh://<user>@<host>/system"
libvirt_uri = "qemu:///system"

### Base image URI for VM ###
# Download the image by:
#   sudo curl -L -o /var/lib/libvirt/images/Rocky-9-GenericCloud.latest.x86_64.qcow2 https://download.rockylinux.org/pub/rocky/9.2/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2 
vm_base_image_uri = "/var/lib/libvirt/images/Rocky-9-GenericCloud.latest.x86_64.qcow2"

# Networking
bridge      = "br0"
cidr        = "192.168.8.0/24"
gateway     = "192.168.8.1"
nameservers = "[\"192.168.8.1\"]"

pool = "default"

vms = [
  {
    name           = "vm1"
    vcpu           = 4
    memory         = 16000                    # in MiB
    disk           = 100 * 1024 * 1024 * 1024 # 100 GB
    ip             = "192.168.8.200"
    mac            = "52:54:00:00:00:00"
    cloudinit_file = "cloud_init.cfg"
    description    = ""
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
    name           = "vm2"
    vcpu           = 4
    memory         = 16000                    # in MiB
    disk           = 100 * 1024 * 1024 * 1024 # 100 GB
    ip             = "192.168.8.201"
    mac            = "52:54:00:00:00:01"
    cloudinit_file = "cloud_init.cfg"
    description    = ""
    volumes = [
      {
        name = "vdb"
        disk = 1024 * 1024 * 1024 * 1024 # 1 TB 
      },
    ]
  },
  {
    name           = "vm3"
    vcpu           = 4
    memory         = 16000                    # in MiB
    disk           = 100 * 1024 * 1024 * 1024 # 100 GB
    ip             = "192.168.8.202"
    mac            = "52:54:00:00:00:02"
    cloudinit_file = "cloud_init.cfg"
    description    = ""
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