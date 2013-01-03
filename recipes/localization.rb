inside 'config/locales' do
  remove_file 'en.yml'
  create_file 'pt-BR.yml', open('https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/pt-BR.yml').read
end
commit 'Add base pt-br locales'


gsub_file 'config/application.rb', /^\s*#\s*(config\.i18n\.default_locale\s*=\s*).*$/, "    \\1'pt-BR'\n    config.i18n.locale = 'pt-BR'"
commit 'Set pt-br as default locale'


gsub_file 'config/application.rb', /^\s*#\s*(config\.time_zone\s*=\s*).*$/, "    \\1'Brasilia'"
commit 'Set "Brasilia" time zone'
