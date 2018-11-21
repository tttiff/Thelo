class AddPriceToBids < ActiveRecord::Migration[5.2]
  def change
    add_monetize :bids, :price, currency: { present: false }
  end
end
