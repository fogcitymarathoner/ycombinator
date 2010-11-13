class Link < ActiveRecord::Base
  has_and_belongs_to_many :research_item
  has_many :tags
  has_many :linkages
end
