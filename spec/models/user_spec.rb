require "rails_helper"

RSpec.describe User, type: :model do
  context "正常な場合" do
    let(:user) { create(:user) }

    it "userが作られる" do
      expect(user.valid?).to eq true
    end
  end

  context "name が指定されていない場合" do
    let(:user) { build(:user, name: nil) }

    it "エラーする" do
      user.valid?
      expect(user.errors.messages[:name]).to include "can't be blank"
    end
  end

  context "name が長すぎる場合" do
    let(:user) { build(:user, name: "a" * 51) }

    it "エラーする" do
      user.valid?
      expect(user.errors.messages[:name]).to include "is too long (maximum is 50 characters)"
    end
  end
end