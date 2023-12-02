class RenameIsStaffToInstructorInClimbers < ActiveRecord::Migration[7.0]
  def change
    rename_column :climbers, :is_staff, :instructor
  end
end
