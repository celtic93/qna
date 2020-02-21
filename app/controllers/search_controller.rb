class SearchController < ApplicationController
  skip_authorization_check

  def search
    @query = params[:search][:query]
    @search_results = Services::Searching.new.call(search_params)
  end

  private

  def search_params
    params.require(:search).permit(:query, :scope)
  end
end
