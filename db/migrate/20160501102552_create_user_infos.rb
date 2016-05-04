class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.string :height
      t.string :weight
      t.string :shangyichima
      t.string :yaowei
      t.string :bichang
      t.string :jiankuan
      t.string :xiongwei
      t.string :datuiwei
      t.string :kuchang
      t.string :xiema

      t.timestamps null: false
    end
  end
end
