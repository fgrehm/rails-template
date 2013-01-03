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
