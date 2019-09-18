require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:gist_link) { Link.new(url: 'https://gist.github.com/TimmyMT/fecb0d211eeaa8ab7409e0ddb13899c6') }
  let(:not_gist_link) { Link.new(url: 'https://google.com') }
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value('http://google.com').for(:url) }
  it { should_not allow_value('google.com').for(:url) }

  it '#gist? true' do
    expect(gist_link).to be_gist
  end

  it '#gist? false' do
    expect(not_gist_link).to_not be_gist
  end

  it '#gist_id return value' do
    expect(gist_link.gist_id).to eq('fecb0d211eeaa8ab7409e0ddb13899c6')
  end

  it '#gist_id return nil' do
    expect(not_gist_link.gist_id).to be_nil
  end
end
