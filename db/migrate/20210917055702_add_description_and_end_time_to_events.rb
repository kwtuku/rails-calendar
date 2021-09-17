class AddDescriptionAndEndTimeToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :description, :text
    add_column :events, :end_time, :datetime, null: false
  end
end
