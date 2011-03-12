class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :term
      t.references :brand

      t.timestamps
    end

    add_index :searches, :brand_id
  end

  def self.down
    drop_table :searches
  end
end
