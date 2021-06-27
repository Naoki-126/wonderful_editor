require "rails_helper"

RSpec.describe User, type: :model do
  context "名前、メールアドレス、パスワードが入力されているとき" do
    let(:user) { build(:user) }

    it "ユーザー登録できる" do
      expect(user).to be_valid
    end
  end

  context "名前しか入力されていない場合" do
    let(:user) { build(:user, email: nil, password: nil) }

    it "エラーが発生する" do
      expect(user).to be_invalid
      # expect(user.errors.details[:password][0][:error]).to eq :blank
      # expect(user.errors.details[:email][0][:error]).to eq :blank
    end
  end

  context "emailがない場合" do
    let(:user) { build(:user, email: nil) }

    it "エラーが発生する" do
      expect(user).to be_invalid
      # expect(user.errors.details[:email][0][:error]).to eq :blank
    end
  end
end
