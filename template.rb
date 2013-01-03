
require 'open-uri'

def remote_template(source, destination = source, config = {})
  if ENV['LOCAL']
    source  = File.expand_path(File.dirname(__FILE__)) + "/templates/#{source}"
  else
    souce = "https://raw.github.com/fgrehm/rails-template/master/#{source}"
  end
  context = instance_eval('binding')

  create_file destination, nil, config do
    ERB.new(open(source).read, nil, '-').result(context)
  end
end

def prompt(question, options)
  answer = ask("     \e[1m\e[32mpromp".rjust(10) + "  \e[0m#{question} \e[33m[#{options[:default_answer]}]\e[0m").strip
  answer.present? ? answer : options[:default_answer]
end

def yes?(question)
  return true unless @customized

  answer = ask "     \e[1m\e[32mpromp".rjust(10) + "  \e[0m#{question} \e[33m(y/n)\e[0m"
  case answer.downcase
  when 'yes', 'y'
    true
  when 'no', 'n'
    false
  else
    yes?(question)
  end
end

def commit(description)
  system 'git add .'
  system 'git add --update .'
  system "git commit -am '#{description}'"
end

@template_language = prompt('Which template engine you want to use?', default_answer: 'slim')

system 'rm Gemfile'
remote_template 'Gemfile', 'Gemfile'

system 'rm .gitignore'
remote_template 'gitignore', '.gitignore'

system 'bundle install'
system 'git init'

commit 'Initial Rails directory structure'


inside 'config/locales' do
  remove_file 'en.yml'
  create_file 'pt-BR.yml', open('https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/pt-BR.yml').read
end
commit 'Add base pt-br locales'


gsub_file 'config/application.rb', /^\s*#\s*(config\.i18n\.default_locale\s*=\s*).*$/, "    \\1'pt-BR'\n    config.i18n.locale = 'pt-BR'"
commit 'Set pt-br as default locale'


inject_into_file 'app/controllers/application_controller.rb', "\n  respond_to :html", :before => "\n  protect_from_forgery"
commit 'Setup application controller to respond to html'


remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'
commit 'Remove static files'


gsub_file 'config/application.rb', /^\s*#\s*(config\.time_zone\s*=\s*).*$/, "    \\1'Brasilia'"
commit 'Set "Brasilia" time zone'


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


initializer 'generators.rb', <<-RUBY
Rails.application.config.generators do |g|
  g.stylesheets = false
  g.javascripts = false
  g.helper      = false

  g.test_framework = :rspec
  g.view_specs     = false
  g.routing_specs  = false
  g.request_specs  = false

  g.fixture_replacement :factory_girl
end
RUBY
commit 'Add generators initializer'


remote_template 'dot_rspec', '.rspec'
remote_template 'spec_helper.rb', 'spec/spec_helper.rb'
remote_template 'simplecov_setup.rb', 'spec/simplecov_setup.rb'
rakefile "coverage.rake", <<-CODE
desc 'Run specs with code coverage enabled'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task["spec"].execute
end
CODE
commit 'Setup rspec with simplecov support'


empty_directory 'spec/javascripts'
inside 'spec/javascripts' do
  create_file 'spec.js.coffee', open('https://raw.github.com/bradphelan/jasminerice/master/lib/generators/jasminerice/templates/spec.js.coffee').read
  create_file 'spec.css', open('https://raw.github.com/bradphelan/jasminerice/master/lib/generators/jasminerice/templates/spec.css').read
end
commit 'Set up guard:jasmine / jasminerice'


system 'rm Rakefile'
remote_template 'Rakefile', 'Rakefile'
commit 'Setup default rake task and guard:jasmine task'


inside 'app/assets' do
  system 'rm javascripts/application.js'
  system 'rm stylesheets/application.css'
  remote_template 'application.js.coffee', 'javascripts/application.js.coffee'
  remote_template 'application.css.scss',  'stylesheets/application.css.scss'
end
commit 'Convert application.js to coffee and application.css to sass'


system 'bundle exec guard init'
commit 'Add Guardfile'


remote_template 'Vagrantfile', 'Vagrantfile'
remote_template 'setup_vagrant', 'script/setup_vagrant'
chmod 'script/setup_vagrant', 0755
commit 'Set up Vagrant'


remote_template 'unicorn.rb', 'config/unicorn.rb'
commit 'Add Unicorn config'


remote_template 'Procfile', 'Procfile'
remote_template 'dot_env.sample', '.env.sample'
system 'cp .env.sample .env'
commit 'Add Procfile to start unicorn loading config file'


system 'rm README.rdoc'
remote_template 'README.md', 'README.md'
commit 'Add README.md'


logger_fix = <<-RUBY
# Fix Rails' logger on Heroku
  # See: http://help.papertrailapp.com/discussions/questions/116-logging-from-heroku-apps-using-unicorn
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get(ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'INFO')
RUBY
application logger_fix, :env => 'production'
commit 'Fix Rails logger on Heroku'


system 'cp config/environments/production.rb config/environments/staging.rb'
commit 'Replicate production configs for staging'

bullet_init = <<-RUBY
config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.disable_browser_cache = true
  end
RUBY
application bullet_init, :env => 'development'
commit 'Setup bullet'


create_file 'config/initializers/rails_footnotes.rb', open('https://raw.github.com/josevalim/rails-footnotes/master/lib/generators/templates/rails_footnotes.rb').read
commit 'Setup rails footnotes'
