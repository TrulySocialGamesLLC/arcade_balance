#!/bin/bash
# Forwards the Rails .log to the Docker logs.
set -e

if [[ $RAILS_ENV != "test" ]]; then
	if [[ -e /home/app/pgr-server/log/$RAILS_ENV.log ]]; then
		exec tail -0f /home/app/pgr-server/log/$RAILS_ENV.log
	else
		exec sleep 10
	fi
fi