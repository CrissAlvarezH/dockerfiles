# TODO validate env vars

# TODO exports env vars to aws cli

pg_dump $POSTGRES_HOST_OPTS $DB | gzip > dump.sql.gz

cat dump.sql.gz | aws $AWS_ARGS s3 cp - "s3://${S3_BUCKET}${S3_PREFIX}${DB}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz" || exit 2