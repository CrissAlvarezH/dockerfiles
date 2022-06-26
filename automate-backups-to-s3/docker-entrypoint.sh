#!/bin/sh

echo "init cron tab: $CRON_EXPRESSION"

mkdir /logs

DB_CRON="$CRON_EXPRESSION sh /app/upload_pg_backups.sh >> /logs/db_backups.logs"
FILES_CRON="$CRON_EXPRESSION sh /app/upload_static_files.sh >> /logs/files_backups.logs"

# register crons
echo "$DB_CRON" >> /etc/crontabs/root 
echo "$FILES_CRON" >> /etc/crontabs/root

crond -f -l 8
