class AddDefaultRoleToUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :users, :role, :string, default: "client"
    User.update_all(role: "client")
  end

  def down
    change_column :users, :role, :string, default: nil
  end
end
