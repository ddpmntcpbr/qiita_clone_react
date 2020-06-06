require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context "カレントユーザーが下書きの articles を保存している場合" do
      before do
        create_list(:article, 3, user: current_user)
        create_list(:article, 2, :save_draft, user: current_user)
      end

      it "下書き状態の article の一覧が取得できる" do
        subject
        expect(Article.count).to eq 5
        res = JSON.parse(response.body)
        expect(res.length).to eq 2
        expect(res[0].keys).to eq ["id", "title", "body", "status", "created_at", "updated_at", "likes_count", "user"]
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET api/v1/articles/draft/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { create(:user) }

    context "指定した id の article(下書き) が存在する場合" do
      let(:article) { create(:article, :save_draft, user: current_user) }
      let(:article_id) { article.id }

      it "article を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)

        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["status"]).to eq "draft"
        expect(res["created_at"]).to be_present
        expect(res["updated_at"]).to be_present
        expect(res["likes_count"]).to eq article.article_likes.count
        expect(res["user"]["id"]).to eq article.user.id
        expect(res["user"]["name"]).to eq article.user.name
      end
    end

    context "指定した id の article が公開状態の場合" do
      let(:article) { create(:article, user: current_user) }
      let(:article_id) { article.id }

      it "article を取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end