variable "controller_nodes" {
  type = list(object({
    name             = string
    ansible_host     = string
    ansible_ssh_host = string
  }))
}

variable "worker_nodes" {
  type = list(object({
    name             = string
    ansible_host     = string
    ansible_ssh_host = string
  }))
}

variable "ansible_user" {
  type    = string
  default = "root"
}

variable "ansible_ssh_key_path" {
  type    = string
  default = "./artifacts/ssh_key"
}

variable "user_name" {
  type = string
}

variable "github_user" {
  type = string
}

variable "cluster_k3s_version" {
  type = string
}

variable "cluster_token" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_type" {
  type = string
}

variable "lb_public_address" {
  type = string
}

variable "lb_internal_address" {
  type = string
}

variable "lb_interface" {
  type    = string
  default = "enp7s0"
}

variable "lb_port" {
  type    = number
  default = 6443
}

variable "extra_arguments" {
  type    = string
  default = ""
}

variable "cluster_cidr" {
  type    = string
  default = "10.44.0.0/16"
}

variable "service_cidr" {
  type    = string
  default = "10.45.0.0/16"
}

variable "ansible_ssh_key" {
  type      = string
  sensitive = true
}