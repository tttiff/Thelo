class ChangeStatusToDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :bids, :status, :string, :default => "pending"
  end
end
