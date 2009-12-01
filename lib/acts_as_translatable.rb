# ActsAsCommentable
module Mwd
  module Acts #:nodoc:
    module Translatable #:nodoc:

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_translatable
          has_many :translations, :as => :translatable, :dependent => :destroy, :autosave => true
          include Mwd::Acts::Translatable::InstanceMethods
          extend Mwd::Acts::Translatable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods

      end
      
      # This module contains instance methods
      module InstanceMethods
        
        # Return content for a particular locale, if possible, otherwise return the default
        # as stored in the value field.  The localized content is present in the Translations
        # table, with the key 'value' and for a particular locale.
        #
        #  content("es") => "localized data"
        #
        #  content() => "default data"
        def content(locale=nil)
          return value if locale.nil?
          return (translation(locale).nil? ? value : translation(locale).value)
        end

        def content_for(data_key,locale=nil)
          return self.send(data_key.to_sym) if locale.nil?
          return (translation_for(data_key, locale).nil? ? self.send(data_key.to_sym) : translation_for(data_key, locale).value)
        end

        # Assign content, optionally with location
        #
        #  content = "foo" => (Updates 'value' field)
        #  content = {:en_us => "foo", :es => "bar", :default => "quux"} =>
        # (creates or updates multiple translations having the localization
        # denoted by the hash key.  The "default" keypair assigns to the 'value'
        # field)
        def content=(data)
          assign_content_for(:value, data)
        end

        def assign_content_for(data_key, data)
          if data.is_a?(String)
            self.send((data_key.to_s + "=").to_sym, data)
          elsif data.is_a?(Hash)
            data.keys.each do |locale|
              if locale.to_s == "default"
                self.send((data_key.to_s + "=").to_sym, data[locale])
              else
                if (x = translation_for(data_key, locale)).nil?
                  x = self.translations.build(:locale => locale.to_s, :key => data_key.to_s, :value => data[locale])
                else
                  x.value = data[locale]
                  x.save
                end
              end
            end
          else
            raise "content=() expected a String or Hash"
          end
        end

        def complex_content=(data)
          raise "Expected a Hash" unless data.is_a?(Hash)
          data.each_pair do |data_key, keyed_data|
            assign_content_for(data_key, keyed_data)
          end
        end

        private

        # Return translation for key "value" with the given locale.
        #
        #  translation(String) => Translation
        def translation(locale=nil)
          return translation_for(:value, locale)
        end

        def translation_for(data_key, locale=nil)
          return translations.with_locale(locale).for(data_key).first
        end
      end
      
    end
  end
end
