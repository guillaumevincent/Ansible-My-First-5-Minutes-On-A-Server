## How to test safely the playbook

    vagrant up
    cd ..
    ansible-playbook -i test/test_inventory --ask-vault-pass bootstrap_roles.yml

If you only want to test one family (either deb or red):

    ansible-playbook -i test/test_inventory --ask-vault-pass bootstrap_roles.yml -l deb

The vagrant boxes are publicly available, not custom made.
The first time that you run 'vagrant up' can take a very long time (it depends on your connection).


