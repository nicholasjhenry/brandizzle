class CreateBrandsSearches < ActiveRecord::Migration
  def self.up
    create_table :brands_searches, :id => false do |t|
      t.references :brand
      t.references :search
    end

    add_index :brands_searches, :brand_id
    add_index :brands_searches, :search_id
    add_index :brands_searches, [:brand_id, :search_id]
  end

  def self.down
    drop_table :brands_searches
  end
end
