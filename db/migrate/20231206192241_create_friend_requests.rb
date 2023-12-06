class CreateFriendRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :friend_requests do |t|
      t.bigint :sender_id
      t.bigint :receiver_id
      t.string :status

      t.timestamps
    end
  end
end
