#!/bin/bash

version=$1
[ -z $version ] && version=0.1 && echo "\nset defaul version 0.1\n"

docker build -t crissalvarezh/automate-backups-to-s3:$version .

docker tag crissalvarezh/automate-backups-to-s3:$version crissalvarezh/automate-backups-to-s3:latest

docker push crissalvarezh/automate-backups-to-s3:$version
docker push crissalvarezh/automate-backups-to-s3:latest
