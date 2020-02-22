require 'rails_helper'

RSpec.describe Services::Searching do
  it 'searchs everywhere when scope empty' do
    expect(ThinkingSphinx).to receive(:search).with('test')
    Services::Searching.call(query: 'test', scope: '')
  end

  Services::Searching::SCOPES.each do |scope|
    it "calls #{scope}s search" do
      expect(scope.constantize).to receive(:search).with('test')
      Services::Searching.call(query: 'test', scope: scope)
    end
  end

  it 'searchs everywhere when scope is not in list' do
    expect(ThinkingSphinx).to receive(:search).with('test')
    Services::Searching.call(query: 'test', scope: 'other')
  end
end
