# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "ユーザー、タイトル、本文が入力されているとき" do
    let(:user) { create(:user) }
    let(:article) { build(:article, user_id: user.id) }

    it "記事が作成できる" do
      # article = FactoryBot.buld(:article)
      # article = Article.new(title: "test", body: "test_body", user_id: 1)
      expect(article).to be_valid
    end
  end
end
