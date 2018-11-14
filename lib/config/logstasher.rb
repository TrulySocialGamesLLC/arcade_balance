# Only enable logstaher if filebeat is up on the machine
#
def setup_logstasher!(config)
  return if File.exists?("/etc/service/filebeat/down") || ENV['DISABLE_LOGSTASH']

  # Enable the logstasher logs for the current environment
  config.logstasher.enabled                     = true

  config.logstasher.controller_enabled          = true
  config.logstasher.mailer_enabled              = true
  config.logstasher.record_enabled              = true
  config.logstasher.view_enabled                = true
  config.logstasher.job_enabled                 = true
  config.logstasher.suppress_app_log            = true
  config.logstasher.backtrace                   = true
  config.logstasher.logger_path                 = Rails.root.join( "log/#{Rails.env.to_s}.json" )
  config.logstasher.log_controller_parameters   = true

  LogStasher.add_custom_fields_to_request_context do |fields|
    fields[:user_id]      = try(:current_user) && current_user.id
    fields[:time]         = Time.now.utc.to_s
    fields[:country]      = request.headers["HTTP_X_GEOIP_COUNTRY_CODE"]
    fields[:city]         = request.headers["HTTP_X_GEOIP_COUNTRY_CITY"]
    fields[:lat]          = request.headers["HTTP_X_GEOIP_LATITUDE"]
    fields[:lng]          = request.headers["HTTP_X_GEOIP_LONGITUDE"]
    fields[:remote_ip]    = request.remote_ip
    fields[:sender]       = "rails"
  end
end