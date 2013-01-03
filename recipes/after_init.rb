system 'rm Gemfile'
remote_template 'Gemfile', 'Gemfile'

system 'rm .gitignore'
remote_template 'gitignore', '.gitignore'

system 'bundle install'
system 'git init'


commit 'Initial Rails directory structure with custom Gemfile and gitignore'


remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'
commit 'Remove static files'


remote_template('generators.rb', 'config/initializers/generators.rb')
commit 'Add generators initializer'
