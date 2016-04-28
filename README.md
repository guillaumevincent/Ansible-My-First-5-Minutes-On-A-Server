# Ansible My First 5 Minutes On A Server

Use this playbook if you want to improve the security of your server and want to :

  - change root password
  - add admin user of your choice
  - add authorized keys for admin user
  - add admin user in sudoers
  - install default packages (ufw, fail2ban, ...)
  - install user extra packages
  - setup firewall
  - disallow password authentication
  - disallow root SSH access
  - setup the time


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

    ansible all --user=<SUDOER> --private-key=<SSH_PRIVATE_KEY> --inventory-file='<IP>,' -m ping

example on a raspberry pi :

    ansible all --user=pi --private-key=~/.ssh/id_rsa --inventory-file='192.168.1.100,' -m ping

    192.168.1.100 | SUCCESS => {
        "changed": false,
        "ping": "pong"
    }

explanations :

  - `ansible all` : run ansible command on all hosts
  - `--user=pi` : ssh with user pi
  - `--private-key=~/.ssh/id_rsa` : path of the ssh key use to connect to the server
  - `--inventory-file='192.168.1.100,'` : specify inventory file. do not forget the comma `,`
  - `-m ping` : run module ping

if the previous command failed, `<SUDOER>` don't have access

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
    PUBLIC_KEYS:
      - ~/.ssh/id_rsa.pub
    TIMEZONE: 'xxxxxx'
    #EXTRA_PACKAGES:
    #  - vim
    #  - htop


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

### Should I change the default SSH port ?

I thought it was a good idea. But running SSH on a port over 1024 (i.e. a non-privileged port) is actually potentially a security vulnerability.
Imagine you run SSH on port 2222 and your ssh daemon crashes. Now any local user can start their own (fake) ssh daemon on port 2222 which could be bad.

See why it's probably better to stay on port 22 [Should I change the default SSH port on linux servers?](http://security.stackexchange.com/a/32311/26203)

Thanks Cryonine

### How to use the inventory file

Having the write 

    --inventory-file='192.168.1.100,'

is not optimal and makes the command innecessarily long quite fast when you add more and more servers. The solution is quite
simple, edit the file called inventoire and add your own list of IPs. Or create your own (remember to also add it to the
.gitignore file). 

    ansible-playbook --private-key=~/.ssh/id_rsa --ask-become-pass --ask-vault-pass -i inventoire bootstrap.yml

If we want to limit the run of the playbook to just one machine:

    ansible-playbook --private-key=~/.ssh/id_rsa --ask-become-pass --ask-vault-pass -i inventoire bootstrap.yml -l server1
