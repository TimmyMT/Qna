every 1.day do
  runner "Services::DailyDigest.send_digest"
end

every 30.minutes do
  command "indexer --config 'home/deployer/qna/current/config/production.sphinx.conf' --all --rotate"
end
