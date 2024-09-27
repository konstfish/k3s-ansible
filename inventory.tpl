---
k3s_cluster:
  children:
    server:
      hosts:
%{ for node in controller_nodes ~}
        "${node.name}":
          ansible_host: "${node.ansible_host}"
          ansible_ssh_host: "${node.ansible_ssh_host}"
          extra_server_args: "--advertise-address ${node.ansible_host} --node-ip ${node.ansible_host} --node-external-ip ${node.ansible_ssh_host} --tls-san ${lb_internal_address} --disable=traefik --disable=servicelb --disable=local-storage {{ common_args }} {{ extra_args }}"
%{ endfor ~}
%{ if worker_nodes != null }
    agent:
      hosts:
%{ for node in worker_nodes ~}
        "${node.name}":
          ansible_host: "${node.ansible_host}"
          ansible_ssh_host: "${node.ansible_ssh_host}"
          extra_agent_args: "--node-ip ${node.ansible_host} --node-external-ip ${node.ansible_ssh_host} {{ common_args }}"
          api_endpoint: "${lb_internal_address}"
%{ endfor ~}
%{ endif ~}
  vars:
    ansible_port: 22
    ansible_user: ${ansible_user}
    ansible_ssh_private_key_file: ${ansible_ssh_key}
    
    user_name: ${user_name}
    github_user: ${github_user}

    k3s_version: ${k3s_version}
    token: ${k3s_token}
    cluster_name: ${cluster_name}
    cluster_type: ${cluster_type}

    lb_public_address: ${lb_public_address}
    lb_internal_address: ${lb_internal_address}
    lb_interface: ${lb_interface}
    lb_port: ${lb_port}

    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"
    common_args: "--flannel-iface {{ lb_interface }} --kubelet-arg='resolv-conf=/etc/k3s-resolv.conf'"
    extra_args: "${extra_arguments}"

    server_config_yaml: |
      cluster-cidr: "${cluster_cidr}"
      service-cidr: "${service_cidr}"
  
    extra_manifests: ${jsonencode(extra_manifests)}