class CreateTables < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :user_name
    end

    create_table :roles do |t|
      t.references :user
      t.string :role_name
    end

    create_table :permissions do |t|
      t.references :role
      t.string :permission_name
    end
  end
end
