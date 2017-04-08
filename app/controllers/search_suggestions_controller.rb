class SearchSuggestionsController < ApplicationController
  def index
    @users= User.search(params[:term]).limit(10).pluck(:name)
    render json: @users
  end
end
