class Services::Searching
  SCOPES = %w(Question Answer Comment User).freeze

  def call(search_params)
    query = ThinkingSphinx::Query.escape(search_params[:query])
    scope = search_params[:scope]

    klass = SCOPES.include?(scope) ? scope.constantize : ThinkingSphinx
    klass.search(query)
  end
end
