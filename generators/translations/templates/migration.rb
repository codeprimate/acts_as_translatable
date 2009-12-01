class CreateTranslationsTable < ActiveRecord::Migration
  def self.up
    create_table :translations, :force => true do |t|
      t.integer :translatable_id
      t.string :translatable_type
      t.string :locale
      t.string :key
      t.text :value
      t.timestamps
    end
    add_index :translations, [:translatable_type, :translatable_id]
    add_index :translations, :locale
    # Auto-generated index name was too long, so index is created by hand here
    self.execute("CREATE  INDEX `fullindex` ON `translations` (`translatable_type`, `translatable_id`, `locale`, `key`)")
  end

  def self.down
    drop_table :translations
  end
end
