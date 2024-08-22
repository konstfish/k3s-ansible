resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    controller_nodes = var.controller_nodes,
    worker_nodes     = var.worker_nodes,

    ansible_user    = var.ansible_user,
    ansible_ssh_key = var.ansible_ssh_key_path,

    user_name   = var.user_name,
    github_user = var.github_user,

    k3s_version  = var.cluster_k3s_version,
    k3s_token    = var.cluster_token,
    cluster_name = var.cluster_name,
    cluster_type = var.cluster_type,

    lb_public_address   = var.lb_public_address,
    lb_internal_address = var.lb_internal_address,
    lb_interface        = var.lb_interface
    lb_port             = var.lb_port

    extra_server_args = var.extra_server_args
    cluster_cidr      = var.cluster_cidr
    service_cidr      = var.service_cidr
  })

  filename = "${path.module}/inventory.yml"

  provisioner "local-exec" {
    command     = <<EOT
      sleep 10 # wait for nodes to be ready
      echo "$SSH_PRIVATE_KEY" > artifacts/ssh_key && chmod 600 artifacts/ssh_key
      ansible-playbook -i inventory.yml playbook/install.yml --extra-vars "kubeconfig_localhost=true kubeconfig_localhost_ansible_host=false"
    EOT
    working_dir = path.module
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "false"
      SSH_PRIVATE_KEY           = nonsensitive(var.ansible_ssh_key)
    }
  }
}