require 'rails_helper'

RSpec.describe AchievementsController, type: :controller do

  describe "GET #index" do
    let(:user) { create(:user) }

    it 'render index' do
      sign_in(user)
      get :index
      expect(response).to render_template :index
    end
  end

end
