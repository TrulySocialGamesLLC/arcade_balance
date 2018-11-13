#!/bin/bash
# Skips nginx startup in test environment
# set -e

if [[ $SKIP_NGINX == "true" ]]; then
	touch /etc/service/nginx/down
fi