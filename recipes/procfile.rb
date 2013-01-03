remote_template 'Procfile', 'Procfile'
remote_template 'dot_env.sample', '.env.sample'
system 'cp .env.sample .env'
commit 'Add Procfile to start unicorn loading config file'
