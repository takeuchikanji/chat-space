require "rails_helper"

RSpec.describe Message, type: :model do
  describe "#create" do

    context 'can save' do
      it "メッセージがあれば保存できるか確認" do
        message = build(:message, image: nil)
        expect(message).to be_valid
      end

      it "画像があれば保存できるか確認" do
        message = build(:message, content: nil)
        expect(message).to be_valid
      end

      it "メッセージと画像があれば保存できるか確認" do
        message = build(:message)
        expect(message).to be_valid
      end
    end


    context 'can not save' do
      it "メッセージも画像もどっちもない時保存ができないか確認" do
        message = build(:message, content: nil, image: nil)
        message.valid?
        expect(message.errors[:content]).to include("を入力してください")
      end

      it "group_idがないと保存ができない確認" do
        message = build(:message, group_id: nil)
        message.valid?
        expect(message.errors[:group]).to include("を入力してください")
      end

      it 'user_idがないと保存ができないか確認' do
        message = build(:message, user_id: nil)
        message.valid?
        expect(message.errors[:user]).to include("を入力してください")
      end
    end

  end
end