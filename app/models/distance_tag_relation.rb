# == Schema Information
#
# Table name: distance_tag_relations
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  distance_id :bigint
#  tag_id      :bigint
#
# Indexes
#
#  index_distance_tag_relations_on_distance_id  (distance_id)
#  index_distance_tag_relations_on_tag_id       (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (distance_id => distances.id)
#  fk_rails_...  (tag_id => tags.id)
#
class DistanceTagRelation < ApplicationRecord
  belongs_to :distance
  belongs_to :tag
end
