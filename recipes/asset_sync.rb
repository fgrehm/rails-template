gsub_file 'config/environments/production.rb',
          /^\s*#\s*(config\.action_controller\.asset_host\s*=\s*).*$/,
          "  \\1\"//\#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com\"\n  config.action_mailer.asset_host = \"http:\#{config.action_controller.asset_host}\""
commit 'Setup asset sync'
