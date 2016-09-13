#!/bin/bash

run_playbook(){
    assert "ansible-playbook -u root -i 'localhost,' -c local -e 'ADMIN_USERNAME=admin' -e 'SSH_PORT=2222' configure_ssh.yml >&2"
}

test_set_ssh_password(){
    run_playbook
    assert "cat /etc/ssh/sshd_config | grep 'Port 2222'" "ssh port is not good"
}

test_disable_password_authentication(){
    run_playbook
    assert_fail "cat /etc/ssh/sshd_config | grep '#PasswordAuthentication'" "PasswordAuthentication should be enable"
    assert "cat /etc/ssh/sshd_config | grep 'PasswordAuthentication no'" "PasswordAuthentication should be set to no"
}

test_disable_root_login(){
    run_playbook
    assert_fail "cat /etc/ssh/sshd_config | grep '#PermitRootLogin'" "PermitRootLogin should be enable"
    assert "cat /etc/ssh/sshd_config | grep 'PermitRootLogin no'" "PermitRootLogin should be set to no"
}
