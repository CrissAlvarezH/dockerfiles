#!/bin/sh

echo "init cron tab: $CRON_EXPRESSION"

CRON="$CRON_EXPRESSION sh /app/upload_pg_backups.sh && sh /app/upload_static_files.sh"

# register crons
echo "$CRON" >> /etc/crontabs/root 

crond -f -l 8
