require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    %w(All Questions Answers Comments Users).each do |attr|
      it "search category: #{attr}" do
        expect(Search).to receive(:find).with('find text', attr)
        get :index, params: { query: 'find text', category: attr }
        expect(response).to render_template :index
      end
    end
  end
end
