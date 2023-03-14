class RenameTextColumnToIntroduction < ActiveRecord::Migration[7.0]
  def change
    rename_column :profiles, :text, :introduction
  end
end
