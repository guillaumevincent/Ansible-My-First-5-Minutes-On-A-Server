#!/bin/bash

run_playbook(){
    assert "ansible-playbook -u root -i 'localhost,' -c local -e 'EXTRA_PACKAGES=htop vim' install_packages.yml >&2"
}

test_fail2ban_exists(){
    run_playbook
    assert_fail "fail2ban -v 2>&1 | grep 'command not found'" "fail2ban is not installed"
}

test_fail2ban_exists(){
    run_playbook
    assert_fail "fail2ban -v 2>&1 | grep 'command not found'" "fail2ban is not installed"
}