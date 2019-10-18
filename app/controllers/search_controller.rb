class SearchController < ApplicationController
  def index
    @resources = Search.find(params[:query], params[:category])
  end
end
