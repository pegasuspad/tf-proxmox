variable "boot_disk" {
  description = <<-EOT
    Configuration for the VM's boot disk:
      
      - datastore: ID of the proxmox storage to which the disk will be saved.
      - size: size of the boot disk, in GB. [Default: 8]
      - ssd: whether the datastore is an SSD or not (Default: false)
  EOT
  type        = object({
    datastore = string
    size      = optional(number, 8)
    ssd       = optional(bool, false)
  })
}

variable "boot_iso_id" {
  description = "ID of the ISO image from which to initialize the boot disk"
  type        = string
}

variable "cloud_init_datastore" {
  description = "ID of the Promox datastore to which the cloud-init drive ISO should be saved"
  type        = string
}

variable "cpu_cores" {
  default     = 2
  description = "Number of CPU cores"
  type        = number
}

variable "data_disk_config" {
  default = []
  description = <<-EOT
Set of data disks to import from another non-bootable VM. This is done so the disks can be preserved in the event 
the primary VM needs to be recreated. Must be a list of objects, each entry of which is a data disk to import. The
structure for the list items is the same as for the proxmox_virtual_environment_vm.disk field.

To determine how these disks are formatted and mounted, see the data_disk_attachment variable.
EOT
  type    = list(object({
    datastore_id      = string
    file_format       = string
    path_in_datastore = string
    size              = number
    ssd               = bool
  }))
}

variable "description" {
  default     = null
  description = "Optional human-readable description"
  type        = string  
}

variable "memory" {
  default     = 512
  description = "RAM allocated to this VM, in megabytes"
  type        = number
}

variable "name" {
  description = "Name for the new virtual machine"
  type        = string  
}

variable "network_config" {
  default     = null
  description = <<EOT
Network parameters for a static IP configuration. If null, dhcp will be used. The following network
configuration options may be set:

  - dns_server: IP addresss of the DNS server to configure, which defaults to the gateway IP
  - dns_search_domain: optional default DNS search domain suffix
  - gateway: IP address of the network gateway
  - ip_address: static ipv4 address to use
  - netmask: netmask in dot notation, which defaults to "255.255.255.0"
EOT
  nullable    = true
  type        = object({
    ip_address        = string
    gateway           = string
    netmask           = optional(string)
    dns_server        = optional(string)
    dns_search_domain = optional(string)
  })
}

variable "proxmox_node" {
  description = "Node name of the Proxmox server on which to create the VM."
  type        = string
}

variable "snippets_datastore" {
  description = "ID of the Promox datastore to which the cloud-init snippets should be saved"
  type        = string
}

variable "startup_delay" {
  default     = null
  description = "Optional delay, in seconds, to wait after this VM is started before starting the next one."
  type        = number
}

variable "startup_phase" {
  default     = "never"
  description = <<-EOT
The startup phase in which to include this VM. Phases are started in sequential order, with all VMs in a
phase being started before the next phase begins. Must be one of the following values (which are shown in the
order they will start up):

  - network: network infrastructure, which starts first
  - infrastructure: other core services to start immediately, such as NFS
  - desktop: user desktops
  - internal: services used internally by the household
  - external: services accessible to external users
  - never: do not automatically start this VM
EOT
  type        = string

  validation {
    condition     = contains([
      "desktop",
      "external",
      "infrastructure", 
      "internal",
      "network", 
      "never"
    ], var.startup_phase)
    error_message = "Valid values for var 'startup_phase' are (network, infrastructure, desktop, internal, external, and never)."
  } 
}

variable "tags" {
  default     = []
  description = "Additional tags to apply to this VM, if any."
  type        = list(string)
}

variable "user_data_file_id" {
  default     = null
  description = "ID of the snippet file containing the cloud-init user-data."
  type        = string
}

variable "vmid" {
  default     = null
  description = "VMID for the new virtual machine, which must be unique. The next available ID is assigned if unspecified."
  nullable    = true
  type        = number
}
