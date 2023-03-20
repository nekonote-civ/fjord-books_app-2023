class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :zipcode, null: false, limit: 7
      t.string :address, null: false
      t.text :introduction, null: false

      t.timestamps
    end
  end
end
