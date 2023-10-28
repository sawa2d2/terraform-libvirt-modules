# Usage
Prepare main.tf as follow: 
```
module "my_module" {
  source                  = "github.com/sawa2d2/terraform-modules//kvm-cloudinit/"
  libvirt_uri             = "qemu:///system"
  vm_base_image_uri       = "/var/lib/libvirt/images/Rocky-9-GenericCloud.latest.x86_64.qcow2"
  virtual_bridge          = "br0"
  gateway                 = "192.168.8.1"
  nameservers             = "[\"192.168.8.1\"]"
  cloud_init_cfg_path     = "${path.module}/cloud_init.cfg"
  network_config_cfg_path = "${path.module}/network_config.cfg.tpl"
  vms = [
    {
      name        = "str"
      vcpu        = 4
      memory      = 16000                    # in MiB
      disk        = 100 * 1024 * 1024 * 1024 # 100 GB
      ip          = "192.168.8.200/24"
      mac         = "52:54:00:00:00:00"
      description = ""
    }
  ]
}
```
