module RailsAdmin
  module Config
    module Actions
      class WeeklyLeaderboard < RailsAdmin::Config::Actions::Base

        # This ensures the action only shows up for Tournaments
        register_instance_option :visible? do
          authorized?
        end

        # We want the action on collection
        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :link_icon do
          'fa fa-list'
        end

        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end

        register_instance_option :controller do
          Proc.new do
            if request.post?
              Leaderboard::GiveReward.call(request.params[:user_id].to_i, request.params[:date].to_time(:utc).strftime('%FT%TZ'), request.params[:challenge_id].to_i, 'weekly')
              redirect_to @_request.env['HTTP_REFERER']
            else
              @winners_data = if request.params[:date] && request.params[:challenge_id]
                                Leaderboard::WinnersData.call(request.params[:date], request.params[:challenge_id], 'weekly')
                              else
                                {}
                              end

              render :weekly_leaderboard
            end
          end
        end
      end
    end
  end
end
