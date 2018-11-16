module RailsAdmin
  module Config
    module Actions
      class UpdateConfiguration < RailsAdmin::Config::Actions::Base
        
        # This ensures the action only shows up for game design
        register_instance_option :visible? do
          object = bindings[:object]
          object.is_a?(Configuration) && object.persisted?
        end

        # We want the action on members, not the game design collection
        register_instance_option :member do
          true
        end

        # Customize action icon
        register_instance_option :link_icon do
          'icon-edit'
        end

        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end

        register_instance_option :http_methods do
          [:get, :post, :put]
        end

        register_instance_option :controller do
          proc do
            if request.get?
              session[:rails_admin_return_to] = request.referer
              render action: "update_configuration"
            end

            if request.post?
              @configuration = Configuration.find( request.params[:id] )
              @media_file    = Media::File.create!( owner: @configuration, data: request.params[:configuration][:data] )

              @strategy      = GameDesign::UploadManager.diff!( @configuration, @media_file )

              render action: "update_configuration_diff"
            end

            if request.put?
              @configuration = Configuration.find( request.params[:id] )
              @media_file    = Media::File.find( request.params[:configuration][:media_file_id] )

              GameDesign::UploadManager.update!( @configuration, @media_file )

              # Arcade::User.where( configuration_id: @configuration.id ).update_all( dirty_unlocks: true )

              redirect_to "/backoffice/configuration/#{ @configuration.id }"
            end
          end
        end
        
      end
    end
  end
end