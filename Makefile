requirements:
	ansible-galaxy install -r collections/requirements.yml

install:
	ansible-playbook -i inventory.yaml -b playbook/install.yml

site:
	ansible-playbook -i inventory.yaml -b playbook/site.yml

uninstall:
	ansible-playbook -i inventory.yaml -b playbook/uninstall.yml

upgrade:
	ansible-playbook -i inventory.yaml -b playbook/upgrade.yml