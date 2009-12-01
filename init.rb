# Include hook code here
require 'acts_as_translatable'
ActiveRecord::Base.send(:include, Mwd::Acts::Translatable)
