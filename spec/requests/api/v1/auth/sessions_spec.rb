require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "メールアドレス、パスワードが正しいとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }

      it "header 情報を取得できる=ログインできる" do
        subject
        header = response.header
        expect(header["uid"]).to be_present
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailが一致しない時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: "fff", password: user.password) }

      it "header 情報を取得できない=ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["uid"]).to be_blank
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "passwordが一致しない時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "fff") }

      it "header 情報を取得できない=ログインできない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["uid"]).to be_blank
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # describe "DELETE /api/v1/auth/sign_out" do
  #   subject { delete(destroy_api_v1_user_session_path, params: params, headers: headers) }

  #   context "ユーザーがログインからログアウトする時" do
  #     let(:user) { create(:user) }
  #     let(:params) { attributes_for(:user) }
  #     let!(:headers) { user.create_new_auth_token }

  #     fit "トークンを無くしログアウト出来る" do
  #       expect { subject }.to change { user.reload.tokens }.from(be_present).to(be_empty)

  #       res = JSON.parse(response.body)
  #         expect(res["success"]).to be_truthy
  #         expect(user.reload.tokens).to be_blank
  #         expect(response).to have_http_status(:ok)
  #     end
  #   end
  # end
end
