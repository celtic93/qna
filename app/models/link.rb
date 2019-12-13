class Link < ApplicationRecord
  GIST_URL = 'gist.github.com'

  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  def is_gist?
    url.include?(GIST_URL)
  end
end
