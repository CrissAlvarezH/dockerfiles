#!/bin/sh

set -e

# TODO check if there are any folder to upload

# set default values
[ -z $STATIC_FILES_BACKUP_S3_FOLDER ] && STATIC_FILES_BACKUP_S3_FOLDER=static-files

# validate env vars
[ -z $S3_BUCKET -o -z $STATIC_FILES_BACKUP_S3_FOLDER ] \
    && echo "ERROR: S3 variables are required" && exit 2

echo "upload static files"

FOLDER_LOCATION="/backups/static-files"

for FOLDER in $(ls $FOLDER_LOCATION); do
    echo "upload folder: $FOLDER"

    cd $FOLDER_LOCATION
    zip -r "$FOLDER.zip" $FOLDER

    S3_STATIC_FILE_PATH="s3://${S3_BUCKET}/${STATIC_FILES_BACKUP_S3_FOLDER}/$FOLDER.zip"

    aws s3 cp "$FOLDER.zip" "$S3_STATIC_FILE_PATH"

    rm -rf "$FOLDER.zip"
done

echo "backup static file finish"