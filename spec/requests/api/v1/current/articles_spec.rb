require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    let!(:article1) { create(:article, user: current_user, created_at: 10.days.ago, updated_at: 1.day.ago) }
    let!(:article2) { create(:article, user: current_user, created_at: 3.days.ago, updated_at: 2.days.ago) }

    context "カレントユーザーが公開状態の articles を保存している場合" do
      before do
        create(:article, :save_draft, user: current_user)
        create(:article)
      end

      it "公開状態の article の一覧が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq 2
        expect(res.map {|d| d["id"] }).to eq [article2.id, article1.id]
        expect(res[0].keys).to eq ["id", "title", "body", "status", "created_at", "updated_at", "likes_count", "user"]
        expect(response).to have_http_status(:ok)
      end
    end
  end
end