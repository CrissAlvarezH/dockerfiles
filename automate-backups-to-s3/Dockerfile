FROM alpine:3.15

# Install packages
RUN apk update
RUN apk add postgresql-client
RUN apk add aws-cli
RUN apk add zip

WORKDIR /app

COPY docker-entrypoint.sh docker-entrypoint.sh
COPY upload_pg_backups.sh upload_pg_backups.sh
COPY upload_static_files.sh upload_static_files.sh

RUN chmod +x ./docker-entrypoint.sh

CMD ./docker-entrypoint.sh
