#!/bin/bash
# Forwards the Rails .log to the Docker logs.
set -e
/usr/bin/filebeat.sh -e -c /etc/filebeat/filebeat.yml -d "publish"