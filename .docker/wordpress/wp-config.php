<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '{{DB_NAME}}');

/** MySQL database username */
define( 'DB_USER', '{{DB_USER}}');

/** MySQL database password */
define( 'DB_PASSWORD', '{{DB_PASSWORD}}');

/** MySQL hostname */
define( 'DB_HOST', '{{CONTAINER_NAME}}_db');

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '0794c4f1b5fed0c856912e2a5d11e9d5a90b9ff9');
define( 'SECURE_AUTH_KEY',  '923a8d2cc5cb32e83e9bea31a275dfa8c9681f72');
define( 'LOGGED_IN_KEY',    '04c936880cbd3c1446cc56e7947713bdf9d93bc7');
define( 'NONCE_KEY',        '65031b8362d1a33c5ec0fb233f3b7b3d791df1f7');
define( 'AUTH_SALT',        'c4c546fd7deeb730ef7db8605a1d58e6222b96b8');
define( 'SECURE_AUTH_SALT', 'eb36945802fe05942bfae94490461d4d3e1a320c');
define( 'LOGGED_IN_SALT',   'ca4b80f89f6abb0a9b88d8f5dcb79538c547a5fb');
define( 'NONCE_SALT',       '3552eddebd6440784142bf108b5f7e173bdcd862');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = '{{WORDPRESS_TABLE_PREFIX}}';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', true);

// If we're behind a proxy server and using HTTPS, we need to alert WordPress of that fact
// see also http://codex.wordpress.org/Administration_Over_SSL#Using_a_Reverse_Proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
	$_SERVER['HTTPS'] = 'on';
}

// WORDPRESS_CONFIG_EXTRA
define( 'DOCKER_ENV', true );
define( 'WP_HOME', 'http://{{HOST}}' );
define( 'WP_DEBUG_LOG', dirname( dirname( __FILE__ ) ) . '/debug.log' );
define( 'RELOCATE', true );


/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
