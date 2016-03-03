Travis Trigger
=====
Trigger Travis CI when you want

## Generate SSH Key for encrypt your access token

```
$ ssh-keygen
```

## Generate new GitHub Personal Access Token

Access to <https://github.com/settings/tokens>, and click "Generate new token".

You need to enable the following scopes:

* repo:status
* repo_deployment
* read:org
* write:repo_hook
* user:email

Click "Generate token" and copy the token to your clipboard.

## Get Travis CI Access Token

```
chmod +x get_travis_token.sh
./get_travis_token.sh
```

## Run Travis Trigger

```
chmod +x travis_trigger.sh
./travis_trigger.sh -u user -r repository -b branch
```

example:
```
./travis_trigger.sh -u xcoo -r travis-trigger -b master
```

with crontab:
```
0 12 * * 1 /path/to/travis_trigger.sh -u xcoo -r travis-trigger -b master
```
