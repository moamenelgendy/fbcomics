class Page < ActiveRecord::Base
  attr_accessible :last_visited, :page_id, :page_name
end
