class AddConfirmationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :confirmation_token, :string, default: nil
    add_column :users, :confirmed_at, :datetime, default: nil
  end
end
