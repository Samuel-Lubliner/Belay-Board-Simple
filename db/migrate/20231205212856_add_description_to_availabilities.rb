class AddDescriptionToAvailabilities < ActiveRecord::Migration[7.0]
  def change
    add_column :availabilities, :description, :string
  end
end
