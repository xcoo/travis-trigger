#!/bin/bash

BASE_DIR=`dirname $0`
TOKEN_DIR=$BASE_DIR/token
LOG_DIR=$BASE_DIR/log
mkdir -p $LOG_DIR

USAGE_MSG="Usage: $0 -u user -r repository [-b branch]"

while getopts u:r:b:h OPT
do
    case $OPT in
        u)  TRAVIS_USER=$OPTARG
            ;;
        r)  TRAVIS_REPO=$OPTARG
            ;;
        b)  TRAVIS_BRANCH=$OPTARG
            ;;
        h)  echo "$USAGE_MSG" >&2
            exit 0
            ;;
        *)  echo "$USAGE_MSG" >&2
            exit 1
            ;;
    esac
done

if [ "$TRAVIS_USER" = "" -o "$TRAVIS_REPO" = "" ]; then
    echo "$USAGE_MSG" >&2
    exit 1
fi

if [ "$TRAVIS_BRANCH" = "" ]; then
    TRAVIS_BRANCH="master"
fi

TRAVIS_TOKEN=`openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in $TOKEN_DIR/travis_token`

if [ $? -ne 0 ]; then
    echo "Error: unable to read $TOKEN_DIR/traivs_token" >&2
    exit 1
fi

echo "Access to API..."
BODY="{
\"request\": {
  \"branch\":\"$TRAVIS_BRANCH\"
}}"
RESULT=`curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -H "Travis-API-Version: 3" \
        -H "Authorization: token $TRAVIS_TOKEN" \
        -d "$BODY" \
        https://api.travis-ci.org/repo/$TRAVIS_USER%2F$TRAVIS_REPO/requests`

if [ $? -ne 0 ]; then
    echo "Error: unable to access to API." >&2
    exit 1
fi

echo "$RESULT" >> $LOG_DIR/travis_trigger.log

if [[ "$RESULT" =~ error ]]; then
    ERROR_MSG=`echo "$RESULT" | grep "error_message"`
    echo "Error: $ERROR_MSG" >&2
    exit 1
else
    echo "Done."
    exit 0
fi
