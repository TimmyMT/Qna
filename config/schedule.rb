every 1.day do
  runner "Services::DailyDigest.send_digest"
end
