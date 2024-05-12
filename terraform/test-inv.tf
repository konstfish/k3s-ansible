locals {
  controller_nodes = [
    {
      name             = "test-0"
      ansible_host     = "10.0.1.51"
      ansible_ssh_host = "10.0.1.51"
    },
    {
      name             = "test-1"
      ansible_host     = "10.0.1.52"
      ansible_ssh_host = "10.0.1.52"
    },
    {
      name             = "test-2"
      ansible_host     = "10.0.1.53"
      ansible_ssh_host = "10.0.1.53"
    }
  ]
}


resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../inventory.tpl", {
    controller_nodes = local.controller_nodes,
    worker_nodes     = null,

    ansible_user    = "ubuntu",
    ansible_ssh_key = "~/.ssh/id_rsa",

    user_name   = "ubuntu",
    github_user = "konstfish",

    k3s_version  = "123",
    k3s_token    = "xxx",
    cluster_name = "test",
    cluster_type = "raspberry",

    lb_public_address   = "1.1.1.1"
    lb_internal_address = "8.8.8.8"
    lb_interface        = "eth0"
    lb_port             = 6443

    extra_server_args = "--disable=traefik --disable=local-storage"
    cluster_cidr      = "10.44.0.0/16"
    service_cidr      = "10.45.0.0/16"
  })
  filename = "${path.module}/ansible/inventory.yml"
}