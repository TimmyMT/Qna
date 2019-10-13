require 'rails_helper'

RSpec.describe NewAnswerNotifyJob, type: :job do
  let(:service) { double 'Service::NewAnswerNotify' }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: other_user) }
  
  before do
    allow(Services::NewAnswerNotify).to receive(:new).and_return(service)
  end
  
  it 'calls Service::NewAnswerNotify#send_notify' do
    expect(service).to receive(:send_notify)
    NewAnswerNotifyJob.perform_now(answer)
  end
end