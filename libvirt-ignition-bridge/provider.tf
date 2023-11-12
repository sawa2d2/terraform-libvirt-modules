terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
    #ignition = {
    #  source  = "terraform-providers/ignition"
    #  version = "1.2.1"
    #}
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}