#!/bin/sh

set -e

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S"): $1"
}

log ""
log "========================================="
log "           FILES BACKUP INIT"
log "-----------------------------------------"
log ""

FOLDER_LOCATION="/backups/static-files"

# check if there are any folder to upload
if [ -z "$(ls -A $FOLDER_LOCATION)" ]; then
    log " static folder is empty"
    exit
fi

# set default values
[ -z $STATIC_FILES_BACKUP_S3_FOLDER ] && STATIC_FILES_BACKUP_S3_FOLDER=static-files

# validate env vars
[ -z $S3_BUCKET -o -z $STATIC_FILES_BACKUP_S3_FOLDER ] \
    && log " ERROR: S3 variables are required" && exit 2

for FOLDER in $(ls $FOLDER_LOCATION); do
    log "- Upload folder: '$FOLDER'"

    cd $FOLDER_LOCATION
    zip -r -q "$FOLDER.zip" $FOLDER

    S3_STATIC_FILE_PATH="s3://${S3_BUCKET}/${STATIC_FILES_BACKUP_S3_FOLDER}/$FOLDER.zip"

    aws s3 cp --quiet "$FOLDER.zip" "$S3_STATIC_FILE_PATH"

    log "- Uploaded file: $S3_STATIC_FILE_PATH"
    
    rm -rf "$FOLDER.zip"

    log ""
done

log "-----------------------------------------"
log "           FILES BACKUP FINISH"
log "========================================="
log ""