#!/usr/bin/env bash
set -x

target="cf api $API_ENDPOINT --skip-ssl-validation"
#echo $target
eval $target

echo "Login....."
login="cf auth $USERNAME $PASSWORD"
#echo $login
eval $login

echo "push the app"
push="cf push -n $HOST -p music-rc/spring-music.*.war"
#echo $push
eval $push
