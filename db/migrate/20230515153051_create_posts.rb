class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :post
      t.string :title
      t.string :body
      t.references :postable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
