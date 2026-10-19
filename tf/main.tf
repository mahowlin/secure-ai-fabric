terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "2.19.0"
    }
    utils = {
      source  = "netascode/utils"
      version = "1.0.2"
    }
  }
}

variable "project_dir" {
  description = "Path to project directory"
  type        = string
  default     = ".."
}

variable "apic_url" {
  description = "APIC URL"
  type        = string
}

variable "apic_username" {
  description = "APIC username"
  type        = string
}

variable "apic_password" {
  description = "APIC password"
  type        = string
  sensitive   = true
}

provider "aci" {
  url      = var.apic_url
  username = var.apic_username
  password = var.apic_password
  insecure = false
}

module "aci" {
  source  = "netascode/nac-aci/aci"
  version = "1.2.0"

  yaml_files = concat(
    [for f in fileset("${var.project_dir}/data", "**/*.yml") : "${var.project_dir}/data/${f}"],
    [for f in fileset("${var.project_dir}/modules", "*.yml") : "${var.project_dir}/modules/${f}"],
    [for f in fileset("${var.project_dir}/defaults", "*.yml") : "${var.project_dir}/defaults/${f}"],
  )

  manage_access_policies    = true
  manage_fabric_policies    = false
  manage_pod_policies       = false
  manage_node_policies      = false
  manage_interface_policies = false
  manage_tenants            = true
}
