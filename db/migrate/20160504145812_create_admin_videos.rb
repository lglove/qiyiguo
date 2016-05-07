class CreateAdminVideos < ActiveRecord::Migration
  def change
    create_table :admin_videos do |t|
      t.string :url
      t.string :name
      t.string :logo

      t.timestamps null: false
    end
  end
end
