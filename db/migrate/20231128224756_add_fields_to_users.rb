class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bio, :string, default: 'add bio ...'
    add_column :users, :is_staff, :boolean, default: false
    add_column :users, :boulder, :boolean, default: false
    add_column :users, :top_rope, :boolean, default: false
    add_column :users, :lead, :boolean, default: false
    add_column :users, :vertical, :boolean, default: false
    add_column :users, :slab, :boolean, default: false
    add_column :users, :overhang, :boolean, default: false
    add_column :users, :beginner, :boolean, default: false
    add_column :users, :intermediate, :boolean, default: false
    add_column :users, :advanced, :boolean, default: false
    add_column :users, :sport, :boolean, default: false
    add_column :users, :trad, :boolean, default: false
    add_column :users, :indoor, :boolean, default: false
    add_column :users, :outdoor, :boolean, default: false
  end
end
