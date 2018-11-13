class Configuration < ApplicationRecord

  # Associations
  #
  has_many :files, as: :owner, class_name: 'Media::File'

  #  Callbacks.
  #
  after_create :consume_configuration


  #  Attribute configuration.
  #
  accepts_nested_attributes_for :files, :allow_destroy => true

  #  Has one association workaround
  #
  def file
    self.files.first
  end

  #  Using cached local copy of the file to parse and import game design data
  #
  def consume_configuration
    GameDesign::UploadManager.consume! self
  end

end