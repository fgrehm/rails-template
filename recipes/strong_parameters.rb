initializer 'strong_parameters.rb', <<-RUBY
# We are using Rails 4.0 strong_parameters extracted as a gem for Rails 3.2
# https://github.com/rails/strong_parameters
class ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
end
RUBY
gsub_file 'config/application.rb',
          /\n\s*(# Enforce whitelist.+?whitelist_attributes\s*=\s*true)\n/m,
          <<-RUBY


    # We are using Rails 4.0 strong_parameters extracted as a gem for Rails 3.2
    # https://github.com/rails/strong_parameters
    config.active_record.whitelist_attributes = false
RUBY
commit 'Setup strong_parameters'


create_file 'lib/templates/rails/strong_parameters_controller/controller.rb', <<-RUBY
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < InheritedResources::Base
<% if options[:singleton] -%>
  defaults singleton: true

<% end -%>
  protected

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def resource_params
      params.require(<%= ":\#{singular_table_name}" %>).permit(<%= attributes.map {|a| ":\#{a.name}" }.sort.join(', ') %>)
    end
end
<% end -%>
RUBY
create_file 'lib/templates/rspec/scaffold/controller_spec.rb', <<-RUBY
require 'spec_helper'

<% module_namespacing do -%>
describe <%= controller_class_name %>Controller do
  pending "add some examples to (or delete) \#{__FILE__}"
end
<% end -%>
RUBY
commit 'Update controller scaffold template'


create_file 'lib/templates/active_record/model/model.rb', <<-RUBY
require 'spec_helper'

<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
<% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
end
<% end -%>
RUBY
commit 'Update model generator template to skip mass assignment sanitization'
