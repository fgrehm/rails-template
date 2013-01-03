remote_template 'unicorn.rb', 'config/unicorn.rb'
commit 'Add Unicorn config'


logger_fix = <<-RUBY
# Fix Rails' logger on Heroku
  # See: http://help.papertrailapp.com/discussions/questions/116-logging-from-heroku-apps-using-unicorn
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get(ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'INFO')
RUBY
application logger_fix, :env => 'production'
commit 'Fix Unicorn Rails logger issue on Heroku'
