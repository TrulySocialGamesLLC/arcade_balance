require Rails.root.join('lib', 'rails_admin', 'update_configuration.rb')
require Rails.root.join('lib', 'rails_admin', 'weekly_leaderboard.rb')
require Rails.root.join('lib', 'rails_admin', 'daily_leaderboard.rb')

RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::UpdateConfiguration)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::WeeklyLeaderboard)
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::DailyLeaderboard)

RailsAdmin.config do |config|

  config.main_app_name = ["PGR Arcade", "admin"]

  ### Popular gems integration

   ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)


  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    update_configuration
    weekly_leaderboard do
      only ['Arcade::Winner']
    end
    daily_leaderboard do
      only ['Arcade::Winner']
    end
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  unless ["assets:precompile", "db:migrate", "db:migrate:reset", "db:create"].include?( ARGV.first )# || Rails.env.test?
    Dir[Rails.root.join('lib', 'rails_admin', '**', '*', '*.rb')].each do |file|
      require file
    end
  end
end
