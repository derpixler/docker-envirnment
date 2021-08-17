#!/usr/bin/env bash
echo 'wordpress init'

WORDPRESS_CONFIG_DIST='.docker/wordpress/wp-config.php'
WORDPRESS_CONFIG='public/wp-config.php'
WORDPRESS_CONFIG_SAMPLE='public/wp-config-sample.php'
WORDPRESS_PLUGIN_HELLO='public/wp-content/plugins/hello.php'
WORDPRESS_THEME_TWENTYTWENTYONE='twentytwentyone'
WORDPRESS_THEMES_PATH='public/wp-content/themes'

if [[ ! -d 'vendor' ]]; then
  composer install
fi

if [[ -f $WORDPRESS_CONFIG_SAMPLE ]]; then
  rm $WORDPRESS_CONFIG_SAMPLE
  rm $WORDPRESS_PLUGIN_HELLO

  mv ${WORDPRESS_THEMES_PATH}/${WORDPRESS_THEME_TWENTYTWENTYONE} ${WORDPRESS_THEMES_PATH}/_${WORDPRESS_THEME_TWENTYTWENTYONE}
  rm -rf ${WORDPRESS_THEMES_PATH}/twenty*
  mv ${WORDPRESS_THEMES_PATH}/_${WORDPRESS_THEME_TWENTYTWENTYONE} ${WORDPRESS_THEMES_PATH}/${WORDPRESS_THEME_TWENTYTWENTYONE}
fi

if [[ (-f "$WORDPRESS_CONFIG_DIST" && ! -f "$WORDPRESS_CONFIG")]]; then
  ENV_FILE='.docker/.env'

  export $(grep -v '^#' $ENV_FILE | xargs)
  if [[ -f "$ENV_FILE" ]]; then
    SED=`which sed`

    echo "Creating wp-config for: https://" $HOST
    $SED "s/{{DB_USER}}/${DB_USER}/g;
          s/{{DB_PASSWORD}}/${DB_PASSWORD}/g;
          s/{{DB_NAME}}/${DB_NAME}/g;
          s/{{WORDPRESS_TABLE_PREFIX}}/${WORDPRESS_TABLE_PREFIX}/g;
          s/{{CONTAINER_NAME}}/${CONTAINER_NAME}/g;
          s/{{HOST}}/${HOST}/g" $WORDPRESS_CONFIG_DIST > $WORDPRESS_CONFIG
  fi
fi
