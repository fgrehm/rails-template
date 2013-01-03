
require 'open-uri'

def remote_template(source, destination = source, config = {})
  if ENV['LOCAL']
    source  = File.expand_path(File.dirname(__FILE__)) + "/templates/#{source}"
  else
    souce = "https://raw.github.com/fgrehm/rails-template/master/templates/#{source}"
  end
  context = instance_eval('binding')

  create_file destination, nil, config do
    ERB.new(open(source).read, nil, '-').result(context)
  end
end

def recipe(source)
  if ENV['LOCAL']
    source  = File.expand_path(File.dirname(__FILE__)) + "/recipes/#{source}.rb"
  else
    souce = "https://raw.github.com/fgrehm/rails-template/master/recipes/#{source}.rb"
  end
  apply source
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

%w(
  after_init
  db
  localization
  responders
  specs
  assets
  vagrant
  unicorn
  procfile
  asset_sync
  caching
  bullet
).each do |r|
  recipe r
end


system 'cp config/environments/production.rb config/environments/staging.rb'
commit 'Replicate production configs for staging'


create_file 'config/initializers/rails_footnotes.rb', open('https://raw.github.com/josevalim/rails-footnotes/master/lib/generators/templates/rails_footnotes.rb').read
commit 'Setup rails footnotes'


system 'bundle exec guard init'
commit 'Add Guardfile'


system 'rm README.rdoc'
remote_template 'README.md', 'README.md'
commit 'Add README.md'
