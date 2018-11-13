#!/bin/bash
set -e

if [[ $RAILS_ENV == "development" ]] || [[ $RAILS_ENV == "test" ]]; then
    /sbin/setuser app bundle install 
fi

if [[ $RAILS_ENV == "staging" ]] || [[ $RAILS_ENV == "uat" ]]; then
    rm -f /etc/service/filebeat/down
fi

/sbin/setuser app mkdir -p tmp/
chown -R app:app .

# /sbin/setuser app bundle exec rake db:await

printf 'waiting for db to startup...'
while true; do
  printf '.'
  if /sbin/setuser app mysql -N -s -u $MYSQL_USER_NAME --password=$MYSQL_ROOT_PASSWORD -h 'central-db' -e "SELECT 1;" 2>/dev/null >/dev/null
  then 
    printf '\nDB started successfully\n'
    break
  fi
done

printf 'waiting for configuration db to startup...'
while true; do
  printf '.'
  if /sbin/setuser app mysql -N -s -u root --password=$CONFIGURATION_SHARD_DB_PASSWORD -h 'configuration-db' -e "SELECT 1;" 2>/dev/null >/dev/null
  then 
    printf '\Configuration DB started successfully\n'
    break
  fi
done

printf 'waiting for social db to startup...'
while true; do
  printf '.'
  if /sbin/setuser app mysql -N -s -u root --password=$SOCIAL_SHARD_DB_PASSWORD -h 'social-db' -e "SELECT 1;" 2>/dev/null >/dev/null
  then 
    printf '\Social DB started successfully\n'
    break
  fi
done


if [[ $DOCKERCLOUD_CONTAINER_HOSTNAME == "app-1" ]] || ([[ $RAILS_ENV == "development" ]] && [[ $SKIP_NGINX != "true" ]]); then 
  if /sbin/setuser app mysql -N -s -u $MYSQL_USER_NAME --password=$MYSQL_ROOT_PASSWORD -h 'central-db' -e "select * from information_schema.tables where table_schema='${DB_NAME}' AND table_name='schema_migrations';" | grep 'schema_migrations'  2>&1 >/dev/null
  then
    /sbin/setuser app bundle exec rake db:migrate
  else
    /sbin/setuser app bundle exec rake db:create:all
    /sbin/setuser app bundle exec rake db:migrate
    /sbin/setuser app bundle exec rake db:seed
  fi
fi