require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "下書き記事が存在する時 " do
      let!(:article1) { create(:article, :draft, user: current_user, updated_at: 1.days.ago) }
      let!(:article2) { create(:article, :draft, user: current_user, updated_at: 5.days.ago) }
      let!(:article3) { create(:article, :draft) }

      it "下書き記事の一覧が取得できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res.length).to eq 2
        expect(res[0]["id"]).to eq article1.id
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      end
    end
  end

  describe "GET /api/v1/articles/drafts/:id " do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "指定したidの下書き記事が存在する時" do
      let(:article_id) { article.id }
      let(:article) { create(:article, :draft, user: current_user) }

      it "その記事を取得出来る" do
        subject
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user_id"]).to eq article.user_id

        expect(response).to have_http_status(:ok)
      end
    end

    context "対象の記事が公開記事である時" do
      let(:article_id) { article.id }
      let(:article) { create(:article, :published, user: current_user) }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "対象の記事が他のユーザーの下書き記事である時" do
      let(:article_id) { 100000 }
      let(:article) { create(:article, :published, user: current_user) }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
