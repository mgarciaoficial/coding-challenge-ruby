class AddTenantTrackInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :req_count, :integer, default: 0
  end
end
