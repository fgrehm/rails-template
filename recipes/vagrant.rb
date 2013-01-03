remote_template 'Vagrantfile', 'Vagrantfile'
remote_template 'setup_vagrant', 'script/setup_vagrant'
chmod 'script/setup_vagrant', 0755
commit 'Set up Vagrant'
