	#!/usr/bin/env bash -e

    SERVERNAME=$(echo "$1" | sed -E -e 's/https?:\/\///' -e 's/\/.*//')
    echo "$SERVERNAME"

    if [[ "$SERVERNAME" =~ .*\..* ]]; then
        echo "Adding certificate for $SERVERNAME"
        echo -n | openssl s_client -connect $SERVERNAME:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | tee /tmp/$SERVERNAME.cert
        sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" /tmp/$SERVERNAME.cert
    else
        echo "Usage: $0 www.site.name"
        echo "http:// and such will be stripped automatically"
    fi
