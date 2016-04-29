## How to test safely the playbook

    vagrant up
    cd ..
    ansible-playbook -i test/test_inventory --ask-vault-pass bootstrap_roles.yml

If you only want to test one family (either deb or red):

    ansible-playbook -i test/test_inventory --ask-vault-pass bootstrap_roles.yml -l deb

The vagrant boxes are publicly available, not custom made.
The first time that you run 'vagrant up' can take a very long time (it depends on your connection).

## Test only one box

For instance the CentOS 7 one:

    vagrant up centos7
    cd ..
    ansible-playbook -i test/test_inventory --ask-vault-pass bootstrap_roles.yml -l red

## Requirements
- vagrant 1.8.1 or later
- ansible 2.0.1.0 or later
- git

## .ssh/config niceness

    Host debian8
      Hostname 192.168.60.20
      User vagrant
      IdentityFile ~/.ssh/id_rsa
    Host ubuntu14
      Hostname 192.168.60.21
      User vagrant
      IdentityFile ~/.ssh/id_rsa
    Host centos7
      Hostname 192.168.60.22
      User vagrant
      IdentityFile ~/.ssh/id_rsa

It's just here for my own convenience.
