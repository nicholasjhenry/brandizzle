class CreateSearchResults < ActiveRecord::Migration
  def self.up
    create_table :search_results do |t|
      t.references :search
      t.text :body
      t.text :source
      t.string :url
      t.timestamps
    end
    add_index :search_results, :search_id
  end

  def self.down
    drop_table :search_results
  end
end
