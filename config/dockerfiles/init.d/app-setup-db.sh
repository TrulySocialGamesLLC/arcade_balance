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


if [[ $DOCKERCLOUD_CONTAINER_HOSTNAME == "balance-1" ]]; then
    /sbin/setuser app bundle exec rake db:create
    /sbin/setuser app bundle exec rake db:migrate
fi
