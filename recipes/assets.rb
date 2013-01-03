inside 'app/assets' do
  system 'rm javascripts/application.js'
  system 'rm stylesheets/application.css'
  remote_template 'application.js.coffee', 'javascripts/application.js.coffee'
  remote_template 'application.css.scss',  'stylesheets/application.css.scss'
end
commit 'Convert application.js to coffee and application.css to sass'
