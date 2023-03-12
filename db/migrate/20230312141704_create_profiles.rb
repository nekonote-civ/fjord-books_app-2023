class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :zipcode, limit: 7
      t.string :address
      t.text :text

      t.timestamps
    end
  end
end
