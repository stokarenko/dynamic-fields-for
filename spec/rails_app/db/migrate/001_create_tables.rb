class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
    end

    create_table :roles do |t|
      t.references :user
      t.string :role_name
    end
  end
end
