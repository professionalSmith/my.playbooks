.PHONY all test clean

pb-workstation:
	ansible-playbook -i inv workstation.yaml
