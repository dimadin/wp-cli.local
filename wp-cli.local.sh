#!/usr/bin/env bash

# Inspired by https://stackoverflow.com/a/7875614

# Arguments are required.
if [ $# -lt 3 ]; then
	echo "usage: $0 <project-name> <db-host-ip> <db-host-port>"
	exit 1
fi

# Set variables from passed arguments.
PROJECT_NAME=$1
DB_HOST_IP=$2
DB_HOST_PORT=$3

# Create WP-CLI config file in project's directory.
cat >${PROJECT_NAME}/wp-cli.local.yml <<EOL
path: app/public
require:
  - wp-cli.local.php
apache_modules:
  - mod_rewrite
EOL

cat ${PROJECT_NAME}/wp-cli.local.yml

# Create PHP file in project's directory that will be always included.
cat >${PROJECT_NAME}/wp-cli.local.php <<EOL
<?php
// We only need different database hostname, everything else is the same.
define( 'DB_HOST', '${DB_HOST_IP}:${DB_HOST_PORT}' );

// We are suppressing errors because DB_HOST will be defined again in wp-config.php.
// If you don't want this, use WP-CLI via Local by Flywheel.
error_reporting( 0 );
@ini_set( 'display_errors', 0 );
define( 'WP_DEBUG', false );
EOL

cat ${PROJECT_NAME}/wp-cli.local.php
