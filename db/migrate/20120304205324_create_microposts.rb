class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.string :user_id
      t.string :integer

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
