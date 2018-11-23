class Milestone < ApplicationRecord

  # Associations
  #
  belongs_to :challenge, class_name: 'Challenge', foreign_key: :challenge_id

end