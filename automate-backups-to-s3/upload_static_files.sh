#!/bin/sh

set -e

echo ""
echo "========================================="
echo "           FILES BACKUP INIT"
echo "-----------------------------------------"
echo ""

FOLDER_LOCATION="/backups/static-files"

# check if there are any folder to upload
if [ -z "$(ls -A $FOLDER_LOCATION)" ]; then
    echo "static folder is empty"
    exit
fi

# set default values
[ -z $STATIC_FILES_BACKUP_S3_FOLDER ] && STATIC_FILES_BACKUP_S3_FOLDER=static-files

# validate env vars
[ -z $S3_BUCKET -o -z $STATIC_FILES_BACKUP_S3_FOLDER ] \
    && echo "ERROR: S3 variables are required" && exit 2

for FOLDER in $(ls $FOLDER_LOCATION); do
    echo "- Upload folder: '$FOLDER'"

    cd $FOLDER_LOCATION
    zip -r -q "$FOLDER.zip" $FOLDER

    S3_STATIC_FILE_PATH="s3://${S3_BUCKET}/${STATIC_FILES_BACKUP_S3_FOLDER}/$FOLDER.zip"

    aws s3 cp "$FOLDER.zip" "$S3_STATIC_FILE_PATH"

    rm -rf "$FOLDER.zip"

    echo ""
done

echo "-----------------------------------------"
echo "           FILES BACKUP FINISH"
echo "========================================="
echo ""