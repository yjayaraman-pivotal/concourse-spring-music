#!/usr/bin/env bash
set -e

target="cf api $API_ENDPOINT --skip-ssl-verify"
echo $target
