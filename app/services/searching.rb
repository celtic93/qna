class Services::Searching
  SCOPES = %w(Question Answer Comment User).freeze

  def self.call(query:, scope: nil)
    query = ThinkingSphinx::Query.escape(query)

    klass = SCOPES.include?(scope) ? scope.constantize : ThinkingSphinx
    klass.search(query)
  end
end
