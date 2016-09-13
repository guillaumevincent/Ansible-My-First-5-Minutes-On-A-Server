#!/bin/bash

setup(){
    sed -ie "s/root:\*/root:password_to_remove/" /etc/shadow
}

run_playbook(){
    assert "ansible-playbook -u root -i 'localhost,' -c local -e 'ADMIN_USERNAME=admin' create_admin_user.yml >&2"
}

test_root_has_no_password(){
    run_playbook
    assert "grep root:*: /etc/shadow" "root password is not empty"
}

test_admin_user_has_not_password(){
    run_playbook
    assert "grep admin:*: /etc/shadow" "admin password is not empty"
}

test_indempotence(){
    run_playbook
    assert_fail "ansible-playbook -u root -i 'localhost,' -c local -e 'ADMIN_USERNAME=admin' create_admin_user.yml | grep -n5 changed["
}

test_create_sudoersd_directory(){
    run_playbook
    assert "ls /etc/sudoers.d" "/etc/sudoers.d directory is absent"
    assert "stat --printf='%a %U %G' /etc/sudoers.d | grep '755 root root'" "/etc/sudoers.d has not the good permissions"
}

test_admin_can_execute_sudo_without_password(){
    run_playbook
    assert "grep 'admin ALL=(ALL) NOPASSWD: ALL' /etc/sudoers.d/admin" "admin is not sudoer"
}

test_set_includedir_in_sudoers(){
    run_playbook
    assert "cat /etc/sudoers | grep -- '#includedir /etc/sudoers.d'" "sudoers.d should be included in /etc/sudoers"
}