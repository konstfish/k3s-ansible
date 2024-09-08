requirements:
	ansible-galaxy install -r collections/requirements.yml

install:
	ansible-playbook -i inventory.yml -b playbooks/install.yml

site:
	ansible-playbook -i inventory.yml -b playbooks/site.yml

uninstall:
	ansible-playbook -i inventory.yml -b playbooks/uninstall.yml

upgrade:
	ansible-playbook -i inventory.yml -b playbooks/upgrade.yml