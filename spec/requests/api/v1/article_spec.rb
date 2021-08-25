require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, :published, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, :published, updated_at: 5.days.ago) }
    let!(:article3) { create(:article, :published) }

    before { create(:article, :draft) }

    it "公開済み記事の一覧が取得出来る（更新順）" do
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

    let!(:user) { create(:user) }

    context "指定したidの記事が存在する時" do
      let(:article_id) { article.id }
      context "対象の記事が公開中である時" do
        let(:article) { create(:article, :published) }

        it "その記事が取得出来る" do
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
    end

    context "対象の記事が下書きである時" do
      let(:article) { create(:article, :draft) }
      let(:article_id) { 100000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    context "公開設定で記事を作成した時" do
      let(:params) { { article: attributes_for(:article, status: "published") } }
      let(:current_user) { create(:user) }
      # FactoyBotでuserを作成: 変数を currnt_user_stub

      # stub
      # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }
      # allow_any_instance_of(A:クラス名).to receive(B:メソッド名).and_return(C:戻り値)とするとAのインスタンスで、Bを呼び出した場合、Cを返す
      let(:headers) { current_user.create_new_auth_token }

      it "公開設定の記事を作成出来る" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq params[:article][:status]
        expect(response).to have_http_status(:ok)
      end
    end

    context "下書き設定で記事を作成した時" do
      let(:params) { { article: attributes_for(:article, status: "draft") } }
      let(:current_user) { create(:user) }

      let(:headers) { current_user.create_new_auth_token }

      it "下書き設定の記事を作成できる" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq params[:article][:status]
        expect(response).to have_http_status(:ok)
      end
    end

    context "不適切な status のパラメータを送信したとき" do
      let(:current_user) { create(:user) }
      let(:params) { attributes_for(:article, status: "foo") }
      let(:headers) { current_user.create_new_auth_token }

      it "エラーになる" do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PATCH(PUT)/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article, :published) } }
    let(:current_user) { create(:user) }

    let(:headers) { current_user.create_new_auth_token }

    context "任意の記事のレコードを更新しようとするとき" do
      let(:article) { create(:article, :draft, user: current_user) }

      it "任意の記事のレコードを更新出来る" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body])

        expect(response).to have_http_status(:ok)
      end
    end

    context "他のuserの記事を更新しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:article_id) { article.id }
    let(:headers) { current_user.create_new_auth_token }

    context "任意の記事を削除したい時" do
      let!(:article) { create(:article, user: current_user) }

      it "任意の記事のレコードを削除出来る" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "他人が所持しているレコードを削除する時" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "記事を削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end
