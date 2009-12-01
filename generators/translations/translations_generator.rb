class TranslationsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template "migration.rb", "db/migrate", {:assigns => {},
        :migration_file_name => "create_translations_table"
      }
    end
  end

  protected

  def banner
    "Usage: #{$0} translation"
  end

end
