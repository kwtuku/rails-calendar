class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.belongs_to :user, null: false
      t.string :name, null: false
      t.datetime :start_time, null: false

      t.timestamps
    end
  end
end
