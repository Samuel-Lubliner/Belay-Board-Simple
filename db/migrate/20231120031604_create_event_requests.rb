class CreateEventRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :event_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :availability, null: false, foreign_key: true
      t.string :status, default: 'pending'

      t.timestamps
    end
  end
end
