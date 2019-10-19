every 1.day do
  runner "Services::DailyDigest.send_digest"
end

every 30.minutes do
  rake "ts:index"
end
