remote_template 'dot_rspec', '.rspec'
remote_template 'spec_helper.rb', 'spec/spec_helper.rb'
# TODO: Use spec/support
remote_template 'simplecov_setup.rb', 'spec/simplecov_setup.rb'
rakefile "coverage.rake", <<-CODE
desc 'Run specs with code coverage enabled'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task["spec"].execute
end
CODE
commit <<-COMMIT
Setup rspec

Extras:
 * simplecov
 * database_cleaner
 * capybara with poltergeist
 * capybara-email
 * rspec-spies
 * shoulda-matchers
 * factory_girl
 * forgery
COMMIT


empty_directory 'spec/javascripts'
inside 'spec/javascripts' do
  create_file 'spec.js.coffee', open('https://raw.github.com/bradphelan/jasminerice/master/lib/generators/jasminerice/templates/spec.js.coffee').read
  create_file 'spec.css', open('https://raw.github.com/bradphelan/jasminerice/master/lib/generators/jasminerice/templates/spec.css').read
end
commit 'Set up guard:jasmine / jasminerice'


system 'rm Rakefile'
remote_template 'Rakefile', 'Rakefile'
commit 'Setup default rake task and guard:jasmine task'
