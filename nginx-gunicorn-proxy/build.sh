#!/bin/bash
set -e

version=$1
[ -z $version ] && version=0.1 && echo "\nset defaul version 0.1\n"

docker build --no-cache -t crissalvarezh/nginx-gunicorn-proxy:$version .

docker tag crissalvarezh/nginx-gunicorn-proxy:$version crissalvarezh/nginx-gunicorn-proxy:latest

echo "\nPush image to DockerHub\n"

docker push crissalvarezh/nginx-gunicorn-proxy:$version
docker push crissalvarezh/nginx-gunicorn-proxy:latest
