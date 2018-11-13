class Media::File < ApplicationRecord

  mount_uploader :data, MediaFileUploader
  belongs_to :owner, polymorphic: true

end