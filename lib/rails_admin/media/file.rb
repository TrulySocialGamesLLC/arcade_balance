RailsAdmin.config do |config|
  config.model ::Media::File do
    navigation_icon 'fa fa-file-text-o'
    
    edit do
      field :data, :carrierwave
    end
  end
end
