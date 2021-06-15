class AddArticleIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :article, foreign_key: true
  end
end
