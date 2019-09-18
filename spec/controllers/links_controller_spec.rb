require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:wrong_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable_id: question.id, linkable_type: question.class.to_s) }

  describe 'DELETE #destroy' do
    context 'linkable_type author' do
      before { login(user) }

      it 'deletes files from question' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to change(Link, :count).by(-1)
      end
    end

    context 'Not author of linkable' do
      before { login(wrong_user) }

      it 'deletes files from question' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
      end
    end

    context 'Guset tries to delete link' do
      it 'deletes files from question' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
      end
    end
  end
end
