class AddInvitationFieldsToEventRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :event_requests, :inviter_id, :bigint
    add_column :event_requests, :invite_status, :string, default: 'pending'

    # Optional: add a foreign key constraint if you want to ensure referential integrity
    add_foreign_key :event_requests, :users, column: :inviter_id

    # Optional: add an index to improve query performance on inviter_id
    add_index :event_requests, :inviter_id
  end
end
