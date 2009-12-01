class Translation < ActiveRecord::Base
  #
  # ACTIVERECORD ASSOCIATIONS
  #
  belongs_to :translatable, :polymorphic => true
  
  # 
  # ACTIVERECORD VALIDATIONS
  #
  validates_presence_of :key
  validates_uniqueness_of :key, :scope => [:translatable_id, :translatable_type, :locale]
  
  #
  # ACTIVERECORD NAMED SCOPES
  #
  named_scope :with_locale, lambda {|l| {:conditions => ["translations.locale = ?", l]}}
  named_scope :for, lambda {|k| {:conditions => ["translations.key = ?", k.to_s]}}
end
