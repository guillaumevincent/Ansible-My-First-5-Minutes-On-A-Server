#!/bin/bash

run_playbook(){
    assert "ansible-playbook -u root -i 'localhost,' -c local -e 'ADMIN_USERNAME=admin' -e 'SSH_PORT=2222' configure_ssh.yml >&2"
}

test_set_ssh_password(){
    run_playbook
    assert "cat /etc/ssh/sshd_config | grep 'Port 2222'" "ssh port is not good"
}
