#!/usr/bin/env bash

echo "Stopping and removing any running containers"
docker-compose rm --stop --force

echo "Removing any local configuration"
rm -f ACCESSTOKEN
rm -f moodle-config.php
rm -f synapse_data/homeserver.db
rm -f synapse_data/homeserver.db-shm
rm -f synapse_data/homeserver.db-wal
rm -f synapse_data/synapse.signing.key

echo "All done"
