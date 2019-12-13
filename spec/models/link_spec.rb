require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  let(:question) { create(:question)}
  let(:link) { create(:link, linkable: question) }
  let(:invalid_link) { create(:link, :invalid, linkable: question) }

  context 'url validation' do
    it 'should raise error for invalid link'  do
      expect { invalid_link }.to raise_error
    end

    it 'not should raise error for valid link' do
      expect { link }.not_to raise_error
    end
  end
end
