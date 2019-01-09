FROM planetgr/arcade-balance-base:latest

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install -j8

WORKDIR /home/app/arcade_balance
ADD . /home/app/arcade_balance

#  Init scripts
COPY ./config/dockerfiles/init.d/app-setup-db.sh /etc/my_init.d/setup-db
RUN chmod +x /etc/my_init.d/setup-db

# Add the nginx site and config
ADD config/dockerfiles/configs/nginx.conf /etc/nginx/sites-enabled/arcade-balance.conf
ADD config/dockerfiles/configs/env.conf /etc/nginx/main.d/rails-env.conf
ADD config/dockerfiles/configs/geoip.conf /etc/nginx/conf.d/geoip.conf
ADD config/dockerfiles/configs/nginx-log.conf /etc/nginx/conf.d/nginx-log.conf

RUN rm -f /etc/service/nginx/down

RUN rm -f /etc/nginx/sites-enabled/default
RUN sed -i -- 's|__GEM_HOME__|'"`ls -d /usr/local/rvm/gems/ruby-2.5.?`"'|g' /etc/nginx/sites-enabled/arcade-balance.conf

ENV SHARD_NAME 'stub'
ENV INITIAL_AUTOINCREMENT_VALUE 1
ENV FACEBOOK_APP_ID 0
ENV FACEBOOK_APP_SECRET 0
ENV POSTGRES_USER root

RUN mkdir -p log 
RUN mkdir -p tmp
RUN mkdir -p public/uploads/tmp
RUN touch log/staging.log
RUN touch log/staging.json
# RUN touch tmp/candy_check_play_store_cache
RUN chown -R app:app *

RUN apt-get update
RUN apt-get install -y tzdata

RUN rm -rf /home/app/arcade_balance/public/assets
RUN bundle exec rake assets:clean
RUN bundle exec rake assets:precompile

RUN chown -R app:app .

ENTRYPOINT ["/sbin/my_init"]
