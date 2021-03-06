class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :mail, null: false
      t.string :password_digest, null: false
      t.boolean :administrator, null: false, default: false

      t.timestamps
    end
  end
end
