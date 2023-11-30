class CreateClimbers < ActiveRecord::Migration[7.0]
  def change
    create_table :climbers do |t|
      t.string :bio, default: 'add bio ...'
      t.boolean :is_staff, default: false
      t.boolean :boulder, default: false
      t.boolean :top_rope, default: false
      t.boolean :lead, default: false
      t.boolean :vertical, default: false
      t.boolean :slab, default: false
      t.boolean :overhang, default: false
      t.boolean :beginner, default: false
      t.boolean :intermediate, default: false
      t.boolean :advanced, default: false
      t.boolean :sport, default: false
      t.boolean :trad, default: false
      t.boolean :indoor, default: false
      t.boolean :outdoor, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
