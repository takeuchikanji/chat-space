require 'rails_helper'

describe MessagesController do
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do

    context 'log in' do
      before do
        login user
        get :index, params: { group_id: group.id }
      end

      it 'indexアクション内のインスタンス変数@messageは期待したものか' do
        expect(assigns(:message)).to be_a_new(Message)
      end

      it '@groupの中身が期待したものか' do
        expect(assigns(:group)).to eq group
      end

      it 'indexに対応したビューに遷移するか' do
        expect(response).to render_template :index
      end
    end

    context 'not log in' do
      before do
        get :index, params: { group_id: group.id }
      end

      it '意図した先へリダイレクトするかnew_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


  describe '#create' do
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

    context 'ログイン中' do
      before do
        login user
      end

      context 'ログイン中で保存できた場合' do
        subject {
          post :create,
          params: params
        }

        it 'message保存できてるか' do
          expect{ subject }.to change(Message, :count).by(1)
        end

        it '意図したリダイレクト先に飛べるかgroup_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      context 'ログイン中で保存できなかった場合' do
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }

        subject {
          post :create,
          params: invalid_params
        }

        it 'does not count up' do
          expect{ subject }.not_to change(Message, :count)
        end

        it 'indexに対応したビューに遷移できるか' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    context 'ログインしていないとき' do

      it '意図したリダイレクト先に飛べるか new_user_session_path' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end