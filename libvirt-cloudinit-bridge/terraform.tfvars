# Localhost:
#   libvirt_uri = "qemu:///system"
# Remote:
#   libvirt_uri = "qemu+ssh://<user>@<remote-host>/system?keyfile=${local.user_home_directory}/.ssh/id_rsa&known_hosts_verify=ignore"
# Remote via bastion:
#   Forward port in advance:
#     $ ssh -C -N -f -L 50000:<remote-user>@<remote-host>:22 <bastion-host> -p <bastion-port>
#   libvirt_uri = "qemu+ssh://<remote-user>@localhost:50000/system?keyfile=${local.user_home_directory}/.ssh/id_rsa&known_hosts_verify=ignore"
libvirt_uri = "qemu:///system"

### Base image URI for VM ###
# Download the image by:
#   sudo curl -L -o /var/lib/libvirt/images/Rocky-9-GenericCloud.latest.x86_64.qcow2 https://download.rockylinux.org/pub/rocky/9.2/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2 
pool              = "default"
vm_base_image_uri = "/var/lib/libvirt/images/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"

# Public network
bridge      = "br0"
cidr        = "192.168.8.0/24"
gateway     = "192.168.8.1"
nameservers = ["192.168.8.1"]


vms = [
  {
    name           = "vm1"
    vcpu           = 4
    memory         = 16000                    # in MiB
    disk           = 100 * 1024 * 1024 * 1024 # 100 GB
    ip             = "192.168.8.101"
    cloudinit_file = "cloud_init.cfg"
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
    ip             = "192.168.8.102"
    cloudinit_file = "cloud_init.cfg"
    volumes = [
      {
        name = "vdb"
        disk = 1024 * 1024 * 1024 * 1024 # 1 TB 
      },
    ]
  },
]