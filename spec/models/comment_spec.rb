require "rails_helper"

RSpec.describe Comment, type: :model do
  context "正常な場合" do
    let(:comment) { create(:comment) }

    it "comment が作られる" do
      expect(comment.valid?).to eq true
    end
  end

  context "body が指定されていない場合" do
    let(:comment) { build(:comment, body: nil) }

    it "エラーする" do
      comment.valid?
      expect(comment.errors.messages[:body]).to include "can't be blank"
    end
  end
end