variable "ssh_public_key_path" {
  description = "Path to SSH public key for VM access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "libvirt_uri" {
  description = "Libvirt connection URI"
  type        = string
  default     = "qemu:///system"
}

variable "libvirt_network" {
  description = "Name of libvirt network to use"
  type        = string
  default     = "host-bridge"
}

variable "libvirt_pool" {
  description = "Name of libvirt storage pool"
  type        = string
  default     = "libvirt_images"
}

variable "base_volume_name" {
  description = "Name of base volume in libvirt pool"
  type        = string
  default     = "k3s-node-ubuntu-24.04.qcow2"
}

variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "control_plane_vcpu" {
  description = "Number of vCPUs for control plane nodes"
  type        = number
  default     = 6
}

variable "control_plane_memory" {
  description = "Memory in MB for control plane nodes"
  type        = number
  default     = 10240
}

variable "worker_vcpu" {
  description = "Number of vCPUs for worker nodes"
  type        = number
  default     = 6
}

variable "worker_memory" {
  description = "Memory in MB for worker nodes"
  type        = number
  default     = 10240
}

variable "disk_size" {
  description = "Disk size in bytes (default 80GB)"
  type        = number
  default     = 85899345920
}

variable "k3s_version" {
  description = "k3s version to install (e.g., v1.31.1+k3s1). Leave empty for latest stable."
  type        = string
  default     = "v1.34.3+k3s1"
}

variable "k3s_token" {
  description = "Shared secret for k3s cluster. Auto-generated if not provided."
  type        = string
  default     = ""
  sensitive   = true
}

variable "bastion_vcpu" {
  description = "Number of vCPUs for bastion host"
  type        = number
  default     = 2
}

variable "bastion_memory" {
  description = "Memory in MB for bastion host"
  type        = number
  default     = 4096
}

variable "postgres_enabled" {
  description = "Whether to provision the shared PostgreSQL VM"
  type        = bool
  default     = false
}

variable "postgres_hostname" {
  description = "Hostname for the shared PostgreSQL VM"
  type        = string
  default     = "pg-01"
}

variable "postgres_ip" {
  description = "Static IP address for the shared PostgreSQL VM"
  type        = string
  default     = "192.168.122.20"
}

variable "postgres_vcpu" {
  description = "Number of vCPUs for the shared PostgreSQL VM"
  type        = number
  default     = 4
}

variable "postgres_memory" {
  description = "Memory in MB for the shared PostgreSQL VM"
  type        = number
  default     = 8192
}

variable "postgres_disk_size" {
  description = "Disk size in bytes for the shared PostgreSQL VM (default 120GB)"
  type        = number
  default     = 128849018880
}

variable "redis_enabled" {
  description = "Whether to provision the shared Redis VM"
  type        = bool
  default     = false
}

variable "redis_hostname" {
  description = "Hostname for the shared Redis VM"
  type        = string
  default     = "redis-01"
}

variable "redis_ip" {
  description = "Static IP address for the shared Redis VM"
  type        = string
  default     = "192.168.122.21"
}

variable "redis_vcpu" {
  description = "Number of vCPUs for the shared Redis VM"
  type        = number
  default     = 2
}

variable "redis_memory" {
  description = "Memory in MB for the shared Redis VM"
  type        = number
  default     = 4096
}

variable "redis_disk_size" {
  description = "Disk size in bytes for the shared Redis VM (default 80GB)"
  type        = number
  default     = 85899345920
}
