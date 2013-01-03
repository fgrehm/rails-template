prepend_file 'app/controllers/application_controller.rb', "require 'app_responder'\n"
inject_into_file 'app/controllers/application_controller.rb', "\n  self.responder = AppResponder\n  respond_to :html\n", :before => "\n  protect_from_forgery"
create_file 'lib/app_responder.rb', <<-RUBY
class AppResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder
end
RUBY
commit 'Setup responders gem'
