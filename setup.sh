#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPTDIR=`pwd`
popd > /dev/null

# Install sqlite3 to set the rate limit override.
docker-compose exec -it synapse apt-get update
docker-compose exec -it synapse apt-get install sqlite3

# Create the moodlebot user.
docker-compose exec -it synapse register_new_matrix_user -c /data/homeserver.yaml -u moodlebot -p password -a

# Update the rate limit.
docker-compose exec -it synapse sqlite3 /data/homeserver.db 'insert into ratelimit_override values ("@moodlebot:synapse", 0, 0);'

# Restart synapse for the rate limit to take effect.
docker-compose restart synapse

# Fetch the access token.
docker-compose exec -it synapse sqlite3 /data/homeserver.db "SELECT token FROM access_tokens WHERE user_id = '@moodlebot:synapse' ORDER BY ID DESC LIMIT 1;" > ACCESSTOKEN
ACCESSTOKEN=`cat ACCESSTOKEN`

# Create a moodle configuration.
cat << EOF > moodle-config.php
<?php

\$CFG->enablecommunicationsubsystem = 1;

if (!property_exists(\$CFG, 'forced_plugin_settings')) {
  \$CFG->forced_plugin_settings = [];
}

\$CFG->forced_plugin_settings['communication_matrix'] = [
  'matrixhomeserverurl' => 'https://synapse:8448',
  'matrixaccesstoken' => '${ACCESSTOKEN}',
  'matrixelementurl' => 'https://element:8081',
];

\$CFG->curlsecurityallowedport = "80
443
8448
";

\$CFG->curlsecurityblockedhosts = '';
EOF


echo "Now run the following in your Moodle directory:"
echo
echo "sed -i '/^require_once.*lib.*setup.php.*$/i require_once(\"${SCRIPTDIR}/moodle-config.php\");' config.php"
