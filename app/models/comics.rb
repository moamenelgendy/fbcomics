class Comics < ActiveRecord::Base
  attr_accessible :comments, :created_time, :likes, :page_id, :page_name, :src_big, :src_small, :title
end
