require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    before do
      question = FactoryBot.create(:question, :with_attachment, user: user)
      @blob_id = question.files.first.blob_id
    end

    context 'Guest' do
      it 'tries to delete files from question' do
        expect { delete :destroy, params: { id: @blob_id }, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end
    end

    context 'Question author' do
      before { login(user) }

      it 'deletes files from question' do
        expect { delete :destroy, params: { id: @blob_id }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
      end
    end

    context 'Not question author' do
      user = User.create(email: 'wrong_user@test.com', password: '123456', password_confirmation: '123456')
      before { login(user) }

      it 'tries to delete files from question' do
        expect { delete :destroy, params: { id: @blob_id }, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end
    end

  end
end
