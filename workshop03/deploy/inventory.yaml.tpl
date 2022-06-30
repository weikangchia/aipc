all:
  vars:
    codeserver_host_ip: ${codeserver_host_ip}
    codeserver_password: ${codeserver_password}
    codeserver_domain: ${codeserver_domain}
  hosts:
    codeserver:
      ansible_host: "{{ codeserver_host_ip }}"
      ansible_conection: ssh
      ansible_user: root
      ansilbe_ssh_private_key_file: ${path_to_private_key}