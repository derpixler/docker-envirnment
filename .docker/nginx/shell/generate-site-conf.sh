SED=`which sed`
CURRENT_DIR=`dirname $0`

DOMAIN=$1
echo "Creating hosting for:" $DOMAIN
$SED "s/{{DOMAIN}}/$DOMAIN/g" $CURRENT_DIR/site-conf.stub > /etc/nginx/sites-available/site.conf
