class ChangeUseridToInteger < ActiveRecord::Migration
  def change
    remove_column(:microposts, :user_id)
    remove_column(:microposts, :integer)
    add_column(:microposts, :user_id, :integer)
  end

end
