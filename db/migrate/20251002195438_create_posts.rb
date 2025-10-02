class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts, if_not_exists: true do |t|
      t.string :title

      t.timestamps
    end
  end
end
