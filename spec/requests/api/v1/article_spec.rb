require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 5.days.ago) }
    let!(:article3) { create(:article) }

    it "記事の一覧が取得出来る" do
      subject

      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在する時" do
      let(:article_id) { article.id }
      let(:article) { create(:article) }

      it "その詳細が取得出来る" do
        subject

        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"].keys).to eq ["id", "name", "email"]

        expect(response).to have_http_status(:ok)
      end
    end

    context "指定したidの記事が存在しない時" do
      let(:article_id) { 10000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params) }

    context "適切なパラメーターを送信した時" do
      let(:params) { { article: attributes_for(:article) } }
      let(:current_user) { create(:user) }
      # FactoyBotでuserを作成: 変数を currnt_user_stub

      # stub
      # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
      # allow_any_instance_of(A:クラス名).to receive(B:メソッド名).and_return(C:戻り値)とするとAのインスタンスで、Bを呼び出した場合、Cを返す

      it "ユーザーの記事を作成出来る" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end

    context "不適切なパラメーターを送信した時" do
      let(:params) { attributes_for(:article) }

      it "エラーする" do
        expect { subject }.to raise_error(NoMethodError)
      end
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
