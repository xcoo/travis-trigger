#!/bin/bash

BASE_DIR=`dirname $0`
TOKEN_DIR=$BASE_DIR/token
mkdir -p $TOKEN_DIR

echo -n "GitHub Private Access Token: "
read GITHUB_TOKEN

echo "Access to API..."
BODY="{
  \"github_token\":\"$GITHUB_TOKEN\"
}"
TRAVIS_JSON=`curl -s -X POST \
             -H "Content-Type: application/json" \
             -H "Accept: application/vnd.travis-ci.2+json" \
             -H "User-Agent: Oghliner" \
             -d "$BODY" \
             https://api.travis-ci.org/auth/github`

if [ $? -ne 0 ]; then
    echo "Error: unable to access to API." >&2
    exit 1
fi

if [[ ! "$TRAVIS_JSON" =~ access_token ]]; then
    echo "Error: not a Travis user." >&2
    exit 1
fi

echo "Writing Travis CI Access Token..."
TRAVIS_TOKEN=`echo $TRAVIS_JSON | cut -d '"' -f 4`
echo $TRAVIS_TOKEN | openssl rsautl -encrypt -inkey ~/.ssh/id_rsa > $TOKEN_DIR/travis_token

if [ $? -ne 0 ]; then
    echo "Error: unable to create $TOKEN_DIR/traivs_token" >&2
    exit 1
else
    echo "Done."
    exit 0
fi
