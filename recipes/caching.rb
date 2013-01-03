gsub_file 'config/environments/production.rb',
          /^\s*#\s*(config\.cache_store\s*=\s*).*$/,
          "  \\1:dalli_store"
application "config.cache_store = :dalli_store\n", :env => 'development'
commit 'Setup caching with dalli'


cache_digests_init = <<-RUBY
# Cache fragments AND track dependent partials changes (with the penalty of recomputing the digests for each request)
  CacheDigests::TemplateDigestor.cache = ActiveSupport::Cache::NullStore.new
RUBY
application cache_digests_init, :env => 'development'
commit 'Setup cache_digests to track dependet partial changes on development'
