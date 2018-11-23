class Challenge < ApplicationRecord

  # Associations
  #
  has_many :milestones, class_name: 'Milestone', dependent: :delete_all

end