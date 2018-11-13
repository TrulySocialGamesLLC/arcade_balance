#!/bin/bash
set -e

if [[ $RAILS_ENV == "staging" ]] || [[ $RAILS_ENV == "uat" ]]; then
    rm -f /etc/service/filebeat/down
fi

/sbin/setuser app mkdir -p tmp/
chown -R app:app .

# /sbin/setuser app bundle exec rake db:await

printf 'waiting for db to startup...'
while true; do
  printf '.'
  if PGPASSWORD="$POSTGRES_PASSWORD" psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -h "arcade-balance-db" --dbname "$POSTGRES_USER" -c "select 1;" 2>&1 >/dev/null
  then 
    printf '\nDB started successfully\n'
    break
  fi
done


if [[ $DOCKERCLOUD_CONTAINER_HOSTNAME == "app-1" ]] || ([[ $RAILS_ENV == "development" ]] && [[ $SKIP_NGINX != "true" ]]); then 
  if /sbin/setuser app mysql -N -s -u $POSTGRES_USER --password=$POSTGRES_PASSWORD -h 'arcade-balance-db' -e "select * from information_schema.tables where table_schema='arcade-balance-db' AND table_name='schema_migrations';" | grep 'schema_migrations'  2>&1 >/dev/null
  then
    /sbin/setuser app bundle exec rake db:migrate
  else
    /sbin/setuser app bundle exec rake db:create
    /sbin/setuser app bundle exec rake db:migrate
    /sbin/setuser app bundle exec rake db:seed
  fi
fi