class CreateAuthTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_tokens do |t|
      t.string    :content, null: false
      t.integer   :user_id, null: false
      t.datetime  :expired_at, null: false, index: true
    end

    add_index :auth_tokens, :content, unique: true
  end
end
