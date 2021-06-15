class AddUserIdToArticleLikes < ActiveRecord::Migration[6.0]
  def change
    add_reference :article_likes, :user, foreign_key: true
  end
end
