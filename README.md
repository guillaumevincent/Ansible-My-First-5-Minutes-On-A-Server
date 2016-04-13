# Ansible My First 5 Minutes On A Server

Use this repository if you want to improve the security of your server and configure automatically :

  - change root password
  - add admin user of your choice
  - add authorized keys for admin user
  - add admin user to sudoers
  - update APT package cache
  - upgrade APT to the latest packages
  - install required packages (ufw, fail2ban, vim, ...)
  - setup ufw
  - allow ssh traffic
  - change ssh port
  - disallow password authentication
  - disallow root SSH access


## tldr

edit personal information in secrets.yml ansible vault (default password: **password**)

    mv secrets.default secrets.yml
    ansible-vault rekey secrets.yml
    ansible-vault edit secrets.yml

run (replace `<SUDOER>`, `<SSH_PRIVATE_KEY>`, `<IP>`)

    ansible-playbook -u <SUDOER> --private-key=<SSH_PRIVATE_KEY> --ask-become-pass  --ask-vault-pass -i '<IP>,' bootstrap.yml


## requirements

  - ansible 2+
  - git

## clone this repository

    git clone https://github.com/guillaumevincent/Ansible-My-First-5-Minutes-On-A-Server
    cd Ansible-My-First-5-Minutes-On-A-Server

## checks

verify that you can ping your server via ssh

    ansible all --user=<SUDOER> --private-key=<SSH_PRIVATE_KEY> --ask-become-pass --inventory-file='<IP>,' -m ping

example on a raspberry pi :

    ansible all --user=pi --private-key=~/.ssh/id_rsa --ask-become-pass --inventory-file='192.168.1.100,' -m ping

    SUDO password: raspberry
    192.168.1.100 | SUCCESS => {
        "changed": false,
        "ping": "pong"
    }

explanations :

  - `ansible all` : run ansible command on all hosts
  - `--user=pi` : ssh with user pi
  - `--private-key=~/.ssh/id_rsa` : path of the ssh key use to connect to the server
  - `--ask-become-pass` : ask root password before running playbook `bootstrap.yml`
  - `--inventory-file='192.168.1.100,'` : specify inventory file. do not forget the comma `,`
  - `-m ping` : run module ping


## modify personal information

All your personal information is stored in an encrypted file with ansible-vault.

move `secrets.default` to `secrets.yml`

    mv secrets.default secrets.yml

change your vault password (existing password: **password**)

    ansible-vault rekey secrets.yml

follow the instructions to change ansible vault password

    Vault password: password
    New Vault password: <YOUR_VAULT_PASSWORD>
    Confirm New Vault password: <YOUR_VAULT_PASSWORD>
    Rekey successful

edit secrets information

    ansible-vault edit secrets.yml

the encrypted information that you need to change :

    ---
    ROOT_PASSWORD: 'xxxxxx'
    ADMIN_PASSWORD: 'xxxxxx'
    ADMIN_USERNAME: admin
    SSH_PORT: 2222
    PUBLIC_KEYS:
      - ~/.ssh/id_rsa.pub


## setup your server

now run bootstrap.yml file

    ansible-playbook --user=<SUDOER> --private-key=<SSH_PRIVATE_KEY> --ask-become-pass  --ask-vault-pass --inventory-file='<IP>,' bootstrap.yml

example

    ansible-playbook --user=pi --private-key=~/.ssh/id_rsa --ask-become-pass --ask-vault-pass --inventory-file='192.168.1.100,' bootstrap.yml


## FAQ

### Can I run bootstrap.yml playbook on multiple IP ?

change the `--inventory-file` parameter

    ansible-playbook .... --inventory-file='<IP>,<IP2>,<IP3>,' bootstrap.yml

### I do not have access to my server via ssh, how do I do?

You need ssh access to use ansible. If you have the password of a sudoer, then copy your **ssh public key** on your server.

    ssh-copy-id -i ~/.ssh/id_rsa.pub <SUDOER>@<IP>

## Left to do

 - delete first `<SUDOER>` if not root or admin

