RailsAdmin.config do |config|
  config.model Configuration do
    navigation_icon 'fa fa-file-text-o'

    field :version
    field :name

    field :files do
      inline_add  true
    end

    nested do
      field :files
    end
    field :initial_data
  end
end
