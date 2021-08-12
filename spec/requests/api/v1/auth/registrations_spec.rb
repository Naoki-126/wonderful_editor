require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "適切なパラメーターを送信した時" do
      let(:params) { attributes_for(:user) }

      it "ユーザーレコードが1つ作成される" do
        expect { subject }.to change { User.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["data"]["name"]).to eq params[:name]
        expect(res["data"]["email"]).to eq params[:email]
        expect(response).to have_http_status(:ok)
      end
    end

    context "password_confimationの値がpasswordと異なるとき" do
      let(:params) { attributes_for(:user, password_confimation: "") }

      it "エラーする" do
        expect { subject }.to raise_error(NameError)
      end
    end

    context "メールアドレス、パスワードが正しいとき" do
      let(:params) { attributes_for(:user) }

      it "ログインできる" do
        subject
        header = response.header
        expect(header["uid"]).to be_present
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "nameが正しくない時" do
      let(:params) { attributes_for(:user, name: "") }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["data"]["name"]).to eq params[:name]
        expect(res["errors"]["name"]).to include "can't be blank"
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "emailが正しくない時" do
      let(:params) { attributes_for(:user, email: "") }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["data"]["email"]).to eq params[:email]
        expect(res["errors"]["email"]).to include "can't be blank"
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # describe "DELETE / registrations" do
  #   subject { delete(api_v1_user_registration_path, headers: headers) }
  #   context "ユーザーがログインしている時" do
  #     let(:user){ create(:user) }
  #     let(:headers) { user.create_new_auth_token}

  #     fit "ログアウト出来る" do
  #       binding.pry
  #       subject
  #       res = JSON.parse(response.body)
  #         expect(res["status"]["success"]).to be_truthy
  #         expect(user.reload.tokens).to be_blank
  #         expect(response).to have_http_status(:ok)
  #     end
  #   end
  # end
end
