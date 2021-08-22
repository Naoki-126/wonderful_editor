# == Schema Information
#
# Table name: article_likes
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint
#  {:foreign_key=>true}_id :bigint
#
# Indexes
#
#  index_article_likes_on_user_id                  (user_id)
#  index_article_likes_on_{:foreign_key=>true}_id  ({:foreign_key=>true}_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ArticleLike < ApplicationRecord
  # validates :user_id, presence: true
  # validates :article_id, presence: true

  belongs_to :user
  belongs_to :article
end
