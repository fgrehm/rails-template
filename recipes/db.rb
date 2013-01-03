remote_template('database.yml.sample', 'config/database.yml.sample')
system 'cp config/database.yml.sample config/database.yml'
commit 'Add sample database yml'


system 'rake db:migrate db:setup'
commit 'Update DB schema'


empty_directory 'db/seeds'
system 'touch db/seeds/.gitkeep'
commit 'Add db/seeds folder'


rakefile "seedbank.rake", <<-CODE
require 'seedbank'
Seedbank.load_tasks
CODE
commit 'Load seedbank rake task'
