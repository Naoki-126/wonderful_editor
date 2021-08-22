class ChangeDatatypeStatusToArticles < ActiveRecord::Migration[6.0]
  def change
    change_column :articles, :status, :string, default: "draft"
  end
end
