class EnableCitextExtension < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'citext'
  end
end
