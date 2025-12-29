
.ONESHELL:
.PHONY: all test clean

pb-role:
	@read -p "Enter name of new Ansible role: " ROLE_NAME; \
	makefiles/ansible.pb-role.sh $$ROLE_NAME

pb-workstation:
	ansible-playbook -i inv workstation.yaml
