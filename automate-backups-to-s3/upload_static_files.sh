#!/bin/sh

set -e

# set default values
[ -z $STATIC_FILES_BACKUP_S3_FOLDER ] && STATIC_FILES_BACKUP_S3_FOLDER=static-files

# validate env vars
[ -z $S3_BUCKET -o -z $STATIC_FILES_BACKUP_S3_FOLDER ] \
    && echo "ERROR: S3 variables are required" && exit 2
[ -z $STATIC_FILES_FOLDERS ] && echo "static files folders is not set, exit" && exit

echo "upload static files"


OIFS="$IFS"
IFS=","

for FOLDER in $STATIC_FILES_FOLDERS; do
    gzip -r "/backup/static-files/$FOLDER" > "/backip/static-files/$FOLDER.zip"

    S3_STATIC_FILE_PATH="s3://${S3_BUCKET}/${STATIC_FILES_BACKUP_S3_FOLDER}/$FOLDER.zip"

    aws s3 cp "/tmp/$FOLDER.zip" "$S3_STATIC_FILE_PATH"

    rm -rf "/tmp/$FOLDER.zip"
done

IFS="$OIFS"
unset OIFS

echo "backup static file finish"