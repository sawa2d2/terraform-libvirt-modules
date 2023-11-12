# Usage

Prepare `main.tf` as follows:
```
module "libvirt_nat" {
  source                  = "github.com/sawa2d2/terraform-modules//libvirt-nat/"

  # Localhost: "qemu:///system"
  # Remote   : "qemu+ssh://<user>@<host>/system"
  libvirt_uri = "qemu:///system"
  
  network_name = "mynet"
  domain       = "example.com"
  bridge_name  = "mybr0"
  cidr         = "192.168.123.0/24"
  nameservers  = ["192.168.123.1"]
  
  # Optional
  dns_hosts = [
    {
      hostname = "app.example.com"
      ip       = "192.168.123.100"
    },
  ]
  
  # Optional
  dnsmasq_options = [
    {
      "option_name" : "address"
      "option_value" : "/example.com/192.168.123.100",
    },
    {
      "option_name" : "ptr-record"
      "option_value" : "100.123.168.192.in-addr.arpa,\"example.com\"",
    },
  ]
}
```
