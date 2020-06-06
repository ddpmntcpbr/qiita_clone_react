require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "正常な場合" do
    let(:article_like) { create(:article_like) }

    it "article_like が作られる" do
      expect(article_like.valid?).to eq true
    end
  end
end