module VotesHelper
  def vote_present?(object)
    if object.votes.find_by(user: current_user).present?
      ["display: none", "display: "]
    else
      ["display: ", "display: none"]
    end
  end
end
