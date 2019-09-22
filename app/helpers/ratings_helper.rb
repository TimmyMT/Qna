module RatingsHelper
  def check_vote_for_rating(resource, user)
    if resource.votes.key?(user.id)
      ["display: none", nil]
    else
      [nil, "display: none"]
    end
  end
end
