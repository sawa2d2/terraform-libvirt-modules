module "kvm_ignition_nat" {
  source            = "github.com/sawa2d2/terraform-modules//kvm-ignition-nat/"
  libvirt_uri       = var.libvirt_uri
  domain            = var.domain
  network_name      = var.network_name
  bridge_name       = var.bridge_name
  cidr              = var.cidr
  nameservers       = var.nameservers
  vm_base_image_uri = var.vm_base_image_uri

  dns_hosts = var.use_dns_instead_of_haproxy ? concat(
    [
      for vm in var.masters : {
        hostname = "api.${var.domain}"
        ip       = vm.ip
      }
    ],
    [
      {
        hostname = "api.${var.domain}"
        ip       = var.bootstrap.ip
      },
    ],
    [
      for vm in var.masters : {
        "hostname" : "api-int.${var.domain}"
        "ip" : vm.ip
      }
    ],
    [
      {
        hostname = "api-int.${var.domain}"
        ip       = var.bootstrap.ip
      },
    ],
  ) : []

  dnsmasq_options = concat(
    [
      {
        option_name  = "address"
        option_value = "/api.${var.domain}/${var.load_balancer_ip}"
      },
      {
        option_name  = "address"
        option_value = "/api-int.${var.domain}/${var.load_balancer_ip}"
      },
      {
        option_name  = "address"
        option_value = "/*.apps.${var.domain}/${var.load_balancer_ip}"
      },
      {
        option_name  = "address"
        option_value = "/bootstrap.${var.domain}/${var.bootstrap.ip}"
      },
    ],
    [
      for vm in var.masters : {
        option_name  = "address",
        option_value = "/${vm.name}.${var.domain}/${vm.ip}"
      }
    ],
    [
      for vm in var.workers : {
        option_name  = "address"
        option_value = "/${vm.name}.${var.domain}/${vm.ip}"
      }
    ],
  )

  vms = concat(
    [var.bootstrap],
    var.masters,
    var.workers,
  )
}
