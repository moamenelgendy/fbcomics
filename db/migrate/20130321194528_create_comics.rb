class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.string :comments
      t.integer :created_time
      t.string :likes
      t.string :page_id
      t.string :page_name
      t.string :src_big
      t.string :src_small
      t.string :title

      t.timestamps
    end
  end
end
