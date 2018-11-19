class AddReferencesToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :user, foreign_key: true
    add_reference :events, :service, foreign_key: true
  end
end
