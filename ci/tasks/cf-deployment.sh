#!/usr/bin/env bash
set -e

target="cf api $API_ENDPOINT --skip-ssl-validation"
echo $target
exec $target

echo "Login....."
login="cf auth $USERNAME $PASSWORD"
echo $login
exec $login

echo "push the app"
push="cf push -n $HOST -p music-rc/spring-music.*.war"
echo $push
exec $push
