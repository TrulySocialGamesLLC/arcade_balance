module RailsAdmin
  module Config
    module Actions
      class Leaderboard < RailsAdmin::Config::Actions::Base
        Challenges = ArcadeBalance::Client.parse <<-'GRAPHQL'
        query {
          challenges {
            id
            type
          }
        }
        GRAPHQL

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
              Leaderboards::GiveReward.call(request.params[:user_id].to_i,
                                            request.params[:date].to_time(:utc).strftime('%FT%TZ'),
                                            request.params[:challenge_id].to_i)

              redirect_to @_request.env['HTTP_REFERER']
            else

              @winners_data = if request.params[:date] && request.params[:challenge_id]
                                Leaderboards::WinnersData.call(request.params[:date], request.params[:challenge_id])
                              else
                                {}
                              end
              gql_challenges = ArcadeBalance::Client.query(Challenges)
              @challenges = gql_challenges.original_hash["data"]["challenges"].map { |ch| [ch['id'], "#{ch['id']} | #{ch['type']}"] }

              render :leaderboard
            end
          end
        end
      end
    end
  end
end
