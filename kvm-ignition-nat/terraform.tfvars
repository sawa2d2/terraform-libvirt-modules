# Localhost: "qemu:///system"
# Remote   : "qemu+ssh://<user>@<host>/system"
libvirt_uri = "qemu:///system"

# Download the image from:
#   $ curl -LO https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/38.20231002.3.1/x86_64/fedora-coreos-38.20231002.3.1-qemu.x86_64.qcow2.xz
#   $ xz -dv *.qcow2.xz
vm_base_image_uri = "/var/lib/libvirt/images/fedora-coreos-38.20231002.3.1-qemu.x86_64.qcow2"

network_name = "okdnet"
cidr         = "10.128.0.0/14"

dnsmasq_options = [
  {
    "option_name" : "address"
    "option_value" : "/coreos.example.com/10.128.0.100",
  },
  {
    "option_name" : "ptr-record"
    "option_value" : "100.0.128.10.in-addr.arpa,\"coreos.example.com\"",
  },
]

vms = [
  {
    name          = "coreos"
    vcpu          = 4
    memory        = 16000                    # in MiB
    disk          = 100 * 1024 * 1024 * 1024 # 100 GB
    ip            = "10.128.0.100"
    mac           = "52:54:00:00:00:00"
    ignition_file = "ignition.ign"
    description   = ""
    volumes       = []
  }
]
