class SearchController < ApplicationController
  skip_authorization_check

  def search
    @query = search_params[:query]
    @search_results = Services::Searching.call(search_params)
  end

  private

  def search_params
    params.require(:search).permit(:query, :scope).to_h.symbolize_keys
  end
end
