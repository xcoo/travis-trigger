#!/bin/bash

BASE_DIR=`dirname $0`
TOKEN_DIR=$BASE_DIR/token
mkdir -p $TOKEN_DIR

echo -n 'GitHub Private Access Token: '
read GITHUB_TOKEN

BODY='{
  "github_token":"'$GITHUB_TOKEN'"
}'

echo 'Access to API...'
TRAVIS_TOKEN=`curl -s -X POST \
             -H "Content-Type: application/json" \
             -H "Accept: application/vnd.travis-ci.2+json" \
             -H "User-Agent: Oghliner" \
             -d "$BODY" \
             https://api.travis-ci.org/auth/github \
             | cut -d '"' -f 4`

echo 'Writing Travis CI Access Token...'
echo $TRAVIS_TOKEN | openssl rsautl -encrypt -inkey ~/.ssh/id_rsa > $TOKEN_DIR/travis_token

echo 'Done.'
