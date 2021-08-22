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
require "rails_helper"

# RSpec.describe ArticleLike, type: :model do
# context "ユーザー、記事が入力されているとき" do
#   let(:user) { create(:user) }
#   let(:article) { create(:article, user_id: user.id) }
#   let(:article_like) { build(:article_like, user_id: user.id, article_id: article.id) }

#   it "いいねが作成できる" do
#     # article_like = FactoryBot.build(:article_like)
#     expect(article_like).to be_valid
#   end
# end
# end
