#output "control_plane_ips" {
#  description = "IP addresses of control plane nodes"
#  value = {
#    for idx, vm in libvirt_domain.control_plane :
#    vm.name => vm.network_interface[0].addresses[0]
#  }
#}

#output "worker_ips" {
#  description = "IP addresses of worker nodes"
#  value = {
#    for idx, vm in libvirt_domain.worker :
#    vm.name => vm.network_interface[0].addresses[0]
#  }
#}

output "k3s_token" {
  description = "k3s cluster token (sensitive)"
  value       = local.k3s_token
  sensitive   = true
}

#output "ssh_access" {
#  description = "SSH access commands"
#  value = merge(
#    {
#      for idx, vm in libvirt_domain.control_plane :
#      vm.name => "ssh ubuntu@${vm.network_interface[0].addresses[0]}"
#    },
#    {
#      for idx, vm in libvirt_domain.worker :
#      vm.name => "ssh ubuntu@${vm.network_interface[0].addresses[0]}"
#    }
#  )
#}

#output "kubeconfig_command" {
#  description = "Command to retrieve kubeconfig from control plane"
#  value       = "ssh ubuntu@${libvirt_domain.control_plane[0].network_interface[0].addresses[0]} 'sudo cat /etc/rancher/k3s/k3s.yaml'"
#}

output "cluster_info" {
  description = "Quick cluster information"
  value = {
    control_plane_count = var.control_plane_count
    worker_count        = var.worker_count
    bastion_ip          = "192.168.122.13"
    postgres_enabled    = var.postgres_enabled
    postgres_ip         = var.postgres_enabled ? var.postgres_ip : null
    k3s_version         = local.k3s_version
    total_vcpu          = (var.control_plane_count * var.control_plane_vcpu) + (var.worker_count * var.worker_vcpu) + var.bastion_vcpu + (var.postgres_enabled ? var.postgres_vcpu : 0)
    total_memory_gb     = ((var.control_plane_count * var.control_plane_memory) + (var.worker_count * var.worker_memory) + var.bastion_memory + (var.postgres_enabled ? var.postgres_memory : 0)) / 1024
  }
}

output "bastion_access" {
  description = "Bastion SSH access command"
  value       = "ssh ubuntu@192.168.122.13 (or via hypervisor: ssh kpi-bastion-01)"
}

output "postgres_access" {
  description = "Shared PostgreSQL VM SSH access command"
  value       = var.postgres_enabled ? "ssh ubuntu@${var.postgres_ip}" : null
}
