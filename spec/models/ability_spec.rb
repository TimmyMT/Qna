require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, :with_attachment, user: user) }
    let!(:other_question) { create(:question, :with_attachment, user: other_user) }
    let!(:answer) { create(:answer, :with_attachment, question: question, user: user) }
    let!(:answer_from_other_question) { create(:answer, question: other_question, user: user) }
    let!(:other_answer) { create(:answer, :with_attachment, question: question, user: other_user) }
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:other_comment) { create(:comment, commentable: question, user: other_user) }
    let!(:question_attachment) { question.files.last }
    let!(:other_question_attachment) { other_question.files.last }
    let!(:answer_attachment) { answer.files.last }
    let!(:other_answer_attachment) { other_answer.files.last }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, other_question, user: user }

      it { should be_able_to :destroy, question, user: user }
      it { should_not be_able_to :destroy, other_question, user: user }

      it { should_not be_able_to [:vote_up, :vote_down, :vote_clear], question, user: user }
      it { should be_able_to [:vote_up, :vote_down, :vote_clear], other_question, user: user }

      it { should be_able_to :destroy, question_attachment, user: user }
      it { should_not be_able_to :destroy, other_question_attachment, user: user }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, other_answer, user: user }

      it { should be_able_to :destroy, answer, user: user }
      it { should_not be_able_to :destroy, other_answer, user: user }

      it { should_not be_able_to [:vote_up, :vote_down, :vote_clear], answer, user: user }
      it { should be_able_to [:vote_up, :vote_down, :vote_clear], other_answer, user: user }

      it { should be_able_to :destroy, answer_attachment, user: user }
      it { should_not be_able_to :destroy, other_answer_attachment, user: user }

      it { should be_able_to :select_best, answer, user: user }
      it { should_not be_able_to :select_best, answer_from_other_question, user: user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }

      it { should be_able_to :update, comment, user: user }
      it { should_not be_able_to :update, other_comment, user: user }

      it { should be_able_to :destroy, comment, user: user }
      it { should_not be_able_to :destroy, other_comment, user: user }
    end
  end
end
