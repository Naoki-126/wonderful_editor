class ChangeDatatypeBodyOfArticles < ActiveRecord::Migration[6.0]
  def change
    change_column :articles, :body, :text
  end
end
