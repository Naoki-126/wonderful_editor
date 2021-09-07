class AddArticleIdToArticleLikes < ActiveRecord::Migration[6.0]
  def change
    add_reference :article_likes, :article, foreign_key: true
  end
end
