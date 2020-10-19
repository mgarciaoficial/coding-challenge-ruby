class CreateTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :tenants do |t|
      t.string :name, null: false
      t.string :api_key, null: false

      t.timestamps
    end
  end
end
