class NewAnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotify.new.send_notify(answer)
  end
end
