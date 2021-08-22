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
FactoryBot.define do
  factory :article_like do
    user { nil }
    article { nil }
  end
end
