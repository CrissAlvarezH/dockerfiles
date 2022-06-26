#!/bin/sh

echo "init cron tab: $CRON_EXPRESSION"

DB_CRON="$CRON_EXPRESSION sh /app/upload_pg_backups.sh >> /logs/db_backups.log"
FILES_CRON="$CRON_EXPRESSION sh /app/upload_static_files.sh >> /logs/files_backups.log"

# register crons
echo "$DB_CRON" >> /etc/crontabs/root 
echo "$FILES_CRON" >> /etc/crontabs/root

crond -f -l 8
