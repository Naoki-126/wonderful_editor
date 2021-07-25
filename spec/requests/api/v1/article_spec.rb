require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 5.days.ago) }
    let!(:article3) { create(:article) }

    it "記事の一覧が取得出来る" do
      subject
      # binding.pry
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end
end

# RSpec.describe "Api::V1::Articles", type: :request do
#   describe "GET /articles" do
#     subject { get(api_v1_articles_path) }
#     # pending "add some examples (or delete) #{__FILE__}"
#     # 作成時間が異なる article を3つ作る

#     let!(:article1) { create(:article, user_id: user.id) }
#     let!(:article2) { create(:article, user_id: user.id) }
#     let!(:article3) { create(:article, user_id: user.id) }
#     let(:user) { create(:user)}

#     fit "記事の一覧が取得できる" do
#       # get api_v1_articles_path
#       subject
#       binding.pry
#        # 作成した article のデータが全て返ってきているか（ article の作成時間をずらしたものを3つ作ってそれが3つとも返ってくるか）
#        res = JSON.parse(response.body)
#        expect(res.length).to eq 3
#        expect(res[0].keys).to eq ["id","title","updated_at","user"]

#       # article = FactoryBot.buld(:article)
#       # article = Article.new(title: "test", body: "test_body", user_id: 1)
#       # ステータスコードが 200 であること
#       expect(response).to have_http_status(200)
#     end
#   end

# end
