# Usage

Prepare `main.tf` as follows:
```
module "kvm_cloudinit" {
  source                  = "github.com/sawa2d2/terraform-modules//kvm-cloudinit/"
  libvirt_uri             = "qemu:///system"
  vm_base_image_uri       = "/var/lib/libvirt/images/Rocky-9-GenericCloud.latest.x86_64.qcow2"
  virtual_bridge          = "br0"
  gateway                 = "192.168.8.1"
  nameservers             = "[\"192.168.8.1\"]"
  vms = [
    {
      name          = "coreos"
      vcpu          = 4
      memory        = 16000                    # in MiB
      disk          = 100 * 1024 * 1024 * 1024 # 100 GB
      ip            = "192.168.8.100/24"
      mac           = "52:54:00:00:00:00"
      ignition_file = "ignition.ign"
      description = ""
      volumes = []
    }
  ]
}
```

