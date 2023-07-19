# Simplified Synapse + Keycloak + Element setup for development

To setup:

```sh
chmod 777 synapse_data
docker compose up -d
sleep 10
./setup.sh
```

This will start a synapse, element, and keycloak container. It will then setup:

- a new `moodlebot` user with a password of `password`
- update the user to not be rate limited
- restart synapse for this to take effect
- retrieve the access token
- create a Moodle configuration file

## Hosts

You probably will want to add aliases to your /etc/hosts file. You can copy/paste these in:

```sh
127.0.0.1 element.container.docker.internal element
127.0.0.1 synapse.container.docker.internal synapse
127.0.0.1 keycloak.container.docker.internal keycloak
```

This will allow you to access the containers locally using the following URLs:

- Element: https://element:8081
- Synapse: https://synapse:8448
- KeyCloak: https://keycloak:8443

There are also non-ssl variants for both Synapse, and KeyCloak:
- Synapse: http://synapse:8008
- KeyCloak: http://keycloak:8080

## Trusting

You may wish to import the CA certificate from `ssl/certs/ca.pem` and trust it as a root certificate.

This will allow you to access the containers easily without any certificate validation issues and may be required for Moodle.

Please note that the certificate included in this repository, was created with a certificate authority whose private key has been destroyed.

This is a single-use Certificate Authority intended for the sole purposes of testing Matrix in Moodle.

If you wish to provide your own certificates, you can use a tool like `mkcert` to create them.

### MacOS

```sh
sudo security add-trusted-cert -d -r trustRoot -k '/Library/Keychains/System.keychain' `pwd`/ssl/certs/ca.pem
```

You will likely also need to add the certificate into the OpenSSL keychain from the OSX Keychain. One tool to help with this is [osx-ca-certs](https://github.com/raggi/openssl-osx-ca).

### Debian / Ubuntu

```sh
sudo cp `pwd`/ssl/certs/ca.pem /usr/local/share/ca-certificates/moodle-synapse-containers-ca.crt
sudo update-ca-certificates
```

### RHEL / CentOS

Wait... people run that junk?

## Moodle configuration

After running the setup, you will find a new `moodle-config.php` file.

If you run the command provided, this should add this file into your Moodle site's config.php.

## Resetting

If you need to reset, you can run the following script to remove the docker containers and all configuration:

```sh
./clean.sh
```

You can also copy the `clean-matrix.php` script into your Moodle directory and run this:
This will remove all configured rooms in Moodle.

```sh
php clean-matrix.php
```

Warning: This is destructive! This is intended for developer usage only!
