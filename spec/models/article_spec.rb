require "rails_helper"

RSpec.describe Article, type: :model do
  context "パラメータが正常かつ下書き保存の場合" do
    let(:article) { build(:article, :save_draft) }

    it "article が下書き保存される" do
      expect(article.valid?).to eq true
      expect(article.status).to eq "draft"
    end
  end

  context "パラメータが正常かつ公開設定の場合" do
    let(:article) { build(:article) }

    it "article が公開される" do
      expect(article.valid?).to eq true
      expect(article.status).to eq "published"
    end
  end

  context "title が指定されていない場合" do
    let(:article) { build(:article, title: nil) }

    it "エラーする" do
      article.valid?
      expect(article.errors.messages[:title]).to include "can't be blank"
    end
  end

  context "titile が長すぎる場合" do
    let(:article) { build(:article, title: "a" * 51) }

    it "エラーする" do
      article.valid?
      expect(article.errors.messages[:title]).to include "is too long (maximum is 50 characters)"
    end
  end

  context "body が指定されていない場合" do
    let(:article) { build(:article, body: nil) }

    it "エラーする" do
      article.valid?
      expect(article.errors.messages[:body]).to include "can't be blank"
    end
  end
end
