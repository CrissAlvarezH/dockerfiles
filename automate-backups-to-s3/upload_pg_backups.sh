#!/bin/sh

set -e

# set default variables
[ -z $POSTGRES_PORT ] && POSTGRES_PORT=5432
[ -z $BACKUP_WITH_TIMESTAMP ] && BACKUP_WITH_TIMESTAMP=true
[ -z $PG_BACKUP_S3_FOLDER ] && PG_BACKUP_S3_FOLDER=databases

# validate env vars
[ -z $POSTGRES_HOST -o -z $POSTGRES_PORT -o -z $POSTGRES_USER -o -z $POSTGRES_PASSWORD ] \
    && echo "ERROR: postgres credentials is required" && exit 2
[ -z $S3_BUCKET -o -z $PG_BACKUP_S3_FOLDER ] \
    && echo "ERROR: S3 variables are required" && exit 2
[ -z $DATABASE_NAMES -o -z $BACKUP_WITH_TIMESTAMP ] \
    && echo "ERROR: DATABASE_NAMES and BACKUP_WITH_TIMESTAMP variables is required" && exit 2

export PGPASSWORD=$POSTGRES_PASSWORD # export pass to pg_dump command use it

OIF="$IFS" # save original IFS (internal file separator) value to restore later
IFS="," # set as , to split $DATABASE_NAMES

for DATABASE in $DATABASE_NAMES; do
    echo "create postgres backup for $DATABASE"
    pg_dump -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $DATABASE | gzip > dump.sql.zip

    echo "upload postgres backup to s3"

    if [ $BACKUP_WITH_TIMESTAMP == "true" ]; then
        S3_DESTINY="s3://${S3_BUCKET}/${PG_BACKUP_S3_FOLDER}/$DATABASE-$(date +"%Y-%m-%dT%H:%M:%SZ").sql.zip"
    else
        S3_DESTINY="s3://${S3_BUCKET}/${PG_BACKUP_S3_FOLDER}/$DATABASE.sql.zip"
    fi

    aws s3 cp ./dump.sql.zip "$S3_DESTINY"

    rm -rf dump.sql.zip  # delete backup file
done

# Restore origin IFS an unset temporal varaible
IFS="$OIFS"
unset OIFS

echo "postgres backup finish"