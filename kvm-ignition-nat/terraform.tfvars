# Localhost: "qemu:///system"
# Remote   : "qemu+ssh://<user>@<host>/system"
libvirt_uri = "qemu:///system"

# Download the image from:
#   $ curl -LO https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/38.20231002.3.1/x86_64/fedora-coreos-38.20231002.3.1-qemu.x86_64.qcow2.xz
#   $ xz -dv *.qcow2.xz
#vm_base_image_uri = "/var/lib/libvirt/images/fedora-coreos-38.20231002.3.1-qemu.x86_64.qcow2"
vm_base_image_uri = "/var/lib/libvirt/images/fedora-coreos-38.20230609.3.0-qemu.x86_64.qcow2"

network_name = "mynet"
domain       = "example.com"
bridge_name  = "mybr0"
cidr         = "10.0.0.0/14"
nameservers  = ["10.1.0.1"]

# Optional:
#dns_hosts = [
#  {
#    hostname = "api.ocp4.example.com"
#    ip       = "192.168.126.5"
#  },
#  {
#    hostname = "api-int.ocp4.example.com"
#    ip       = "192.168.126.5"
#  },
#]

# Optional:
#dnsmasq_options = [
#  {
#    "option_name" : "address"
#    "option_value" : "/coreos.example.com/10.128.0.100",
#  },
#  {
#    "option_name" : "ptr-record"
#    "option_value" : "100.0.128.10.in-addr.arpa,\"coreos.example.com\"",
#  },
#]

vms = [
  {
    name          = "coreos"
    vcpu          = 4
    memory        = 16000                    # in MiB
    disk          = 100 * 1024 * 1024 * 1024 # 100 GB
    ip            = "10.0.0.10"
    mac           = "52:54:00:00:00:00"
    ignition_file = "ignition.ign"
    description   = ""
    volumes       = []
  }
]
