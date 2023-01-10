class AddSeatsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :seats, :integer, default: 0
  end
end
