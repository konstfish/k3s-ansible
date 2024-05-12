---
k3s_cluster:
  children:
    server:
      hosts:
%{ for node in controller_nodes ~}
        "${node.name}":
          ansible_host: "${node.ansible_host}"
          ansible_ssh_host: "${node.ansible_ssh_host}"
          extra_server_args: "--advertise-address ${node.ansible_host} --node-ip ${node.ansible_host} --node-external-ip ${node.ansible_ssh_host} --tls-san ${cluster_lb_internal_ip} --disable=traefik --disable=servicelb --disable=local-storage {{ common_args }}"
%{ endfor ~}
%{if isset($worker_nodes) ~}
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
    token: ${token}

    lb_public_address: ${lb_public_address}
    lb_internal_address: ${lb_internal_address}
    lb_interface: ${lb_interface}
    lb_port: ${lb_port}

    cluster_name: ${cluster_name}
    cluster_type: ${cluster_type}

    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"
    extra_server_args: ${extra_server_args}
    # extra_server_args: "--disable=traefik --disable=local-storage" # --disable=servicelb
    extra_agent_args: ""
    common_args: "--flannel-iface {{ lb_interface }} "
    server_config_yaml: |
      cluster-cidr: "${cluster_cidr}/16"
      service-cidr: "{service-cidr}/16"