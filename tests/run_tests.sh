#!/bin/bash
cd ..
docker build -t tdd-ansible .

declare -a playbooks=("create_admin_user" "configure_ssh")
for playbook in "${playbooks[@]}"
do
    docker run --rm -t tdd-ansible /bin/bash -c "cd $playbook; ../tests/bash_unit test_$playbook.sh"
done

cd tests