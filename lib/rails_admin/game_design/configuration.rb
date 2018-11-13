RailsAdmin.config do |config|
  config.model GameDesign::Configuration do
    navigation_icon 'fa fa-file-text-o'

    field :version
    field :name
    field :initial_data

    field :default
    field :disabled

    field :geo_positions

    field :weight
    
    field :files do
      inline_add  true
    end

    nested do
      field :files
    end
  end
end
