class Genre < ActiveRecord::Base
  has_many :styles
end
