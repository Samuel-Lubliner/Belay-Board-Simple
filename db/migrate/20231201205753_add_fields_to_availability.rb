class AddFieldsToAvailability < ActiveRecord::Migration[7.0]
  def change
    add_column :availabilities, :advanced, :boolean, default: false
    add_column :availabilities, :beginner, :boolean, default: false
    add_column :availabilities, :boulder, :boolean, default: false
    add_column :availabilities, :indoor, :boolean, default: false
    add_column :availabilities, :intermediate, :boolean, default: false
    add_column :availabilities, :lead, :boolean, default: false
    add_column :availabilities, :outdoor, :boolean, default: false
    add_column :availabilities, :overhang, :boolean, default: false
    add_column :availabilities, :slab, :boolean, default: false
    add_column :availabilities, :sport, :boolean, default: false
    add_column :availabilities, :top_rope, :boolean, default: false
    add_column :availabilities, :trad, :boolean, default: false
    add_column :availabilities, :vertical, :boolean, default: false
    add_column :availabilities, :learn, :boolean, default: false
    add_column :availabilities, :location, :string

  end
end
