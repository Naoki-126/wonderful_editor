# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "ユーザー、記事が入力されているとき" do
    let(:user) { create(:user) }
    let(:article) { create(:article, user_id: user.id) }
    let(:article_like) { build(:article_like, user_id: user.id, article_id: article.id) }

    it "いいねが作成できる" do
      # article_like = FactoryBot.build(:article_like)
      expect(article_like).to be_valid
    end
  end
end
