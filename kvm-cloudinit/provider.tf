terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.4"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}