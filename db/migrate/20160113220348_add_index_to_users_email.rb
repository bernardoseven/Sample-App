class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true # this add uniqueness to users email attribute.
  end
end
