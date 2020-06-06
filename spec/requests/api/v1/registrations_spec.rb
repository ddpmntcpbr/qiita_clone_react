require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "必要なパラメータを送信したとき" do
      let(:params) { attributes_for(:user).slice(:name, :email, :password) }

      it "ユーザー登録できる" do
        expect { subject }.to change { User.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq("success")
        expect(res["data"]["id"]).to eq(User.last.id)
        expect(res["data"]["email"]).to eq(User.last.email)
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailが不足しているとき" do
      let(:params) { attributes_for(:user).slice(:name, :password) }

      it "ユーザー登録ができない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["email"]).to match_array ["can't be blank"]
      end
    end

    context "すでに同一のemailが登録されているとき" do
      before { create(:user, email: email) }

      let(:email) { Faker::Internet.email }
      let(:params) { attributes_for(:user, email: email).slice(:name, :email, :password) }

      it "ユーザー登録ができない" do
        expect { subject }.to change { User.count }.by(0)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(res["errors"]["email"]).to match_array ["has already been taken"]
      end
    end
  end

  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    let(:user) { create(:user) }
    context "正しいユーザー情報を送信したとき" do
      let(:params) { { email: user.email, password: user.password } }
      it "ログインできる" do
        subject
        expect(response.headers["uid"]).to be_present
        expect(response.headers["access-token"]).to be_present
        expect(response.headers["client"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "メールアドレスが正しくないとき" do
      let(:params) { { email: "aaaa@aaaa.aaaa", password: user.password } }
      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to be_falsey
        expect(res["errors"]).to include("Invalid login credentials. Please try again.")
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "パスワードが正しくないとき" do
      let(:params) { { email: user.email, password: "a" * 9 } }
      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to be_falsey
        expect(res["errors"]).to include("Invalid login credentials. Please try again.")
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    let(:current_user) { create(:user) }
    context "正しいヘッダー情報を送信したとき" do
      let(:headers) { current_user.create_new_auth_token }
      it "ログアウトできる" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to be true
        expect(response.headers["uid"]).to be_blank
        expect(response.headers["access-token"]).to be_blank
        expect(response.headers["client"]).to be_blank
        expect(response).to have_http_status(:ok)
      end
    end
  end
end