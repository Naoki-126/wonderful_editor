class CreateArticleLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :article_likes, &:timestamps
  end
end
