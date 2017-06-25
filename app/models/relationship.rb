# coding: utf-8
class Relationship < ApplicationRecord
  # "user_id"という名前の属性の場合は不要
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # Rails 5からは不要
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
