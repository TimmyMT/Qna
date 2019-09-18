require 'rails_helper'

RSpec.describe Achievement, type: :model do
  it { should validate_presence_of :name }
  it { should belong_to :question }
  it { should belong_to :user }

  it 'should have one attach image' do
    expect(Achievement.new.image).to be_an_instance_of ActiveStorage::Attached::One
  end

  it 'should validate attach image' do
    expect(Achievement.new(name: 'Award')).not_to be_valid
  end
end
