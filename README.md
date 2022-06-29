# Descripción
Imagenes de docker para realizar tareas y procesos de utilidad general.

# Imagenes

### automate-backups-to-s3
Automatiza la creación de backups de base de datos y de carpetas para enviarlos a un bucket de aws s3, puedes ver la imagen en docker hub [aquí](https://hub.docker.com/r/crissalvarezh/automate-backups-to-s3)

	services:

	    database:
	        image: postgres:14-alpine
	        ports:
	            - "5432:5432"
	        environment:
	            POSTGRES_PASSWORD: 12345
	            POSTGRES_USER: root
	            POSTGRES_DB: dbname

	    automate-backups-to-s3:
	        image: crissalvarezh/automate-backups-to-s3:0.1
	        environment:
	            POSTGRES_HOST: database
	            POSTGRES_USER: root
	            POSTGRES_PASSWORD: 12345
	            POSTGRES_PORT: 5432

	            DATABASE_NAMES: dbname
	            BACKUP_WITH_TIMESTAMP: true
	            S3_BUCKET: backup-files
	            PG_BACKUP_S3_FOLDER: databases
	            STATIC_FILES_BACKUP_S3_FOLDER: static-files

	            CRON_EXPRESSION: 0 0 * * *

	            AWS_ACCESS_KEY_ID: 
	            AWS_SECRET_ACCESS_KEY:
	            AWS_DEFAULT_REGION: 
	        volumes:
	            - ./mock:/backups/static-files

Las carpetas agregadas a `/backups/static-files` serán comprimidas y enviadas al `S3_BUCKET` dentro de la carpeta `STATIC_FILES_BACKUP_S3_FOLDER`, y los backups de base de datos en la carpeta `PG_BACKUP_S3_FOLDER`.

Los backups de las bases de datos tendrán el nombre de la base de datos, en caso de que `BACKUP_WITH_TIMESTAMP` sea `true` se le anexará al nombre la fecha de creación del backup.
Ej: `ubicor-2022-04-03T10:05:02.sql.zip`  y `ubicor.sql.zip` con y sin timestamp.

El proceso de backup será automatizado según el `CRON_EXPRESSION`, ej: `30 10 * * *` creará los backups a las `10:30 am` todos los dias, para crear tus expresiones cron puedes usar [crontab.guru](https://crontab.guru/)

**Los logs producidos por el proceso lucen de la siguiente manera:**

	| 2022-06-29 04:00:00: =========================================
	| 2022-06-29 04:00:00:            PG BACKUP INIT
	| 2022-06-29 04:00:00: -----------------------------------------
	| 2022-06-29 04:00:00:
	| 2022-06-29 04:00:00: - Create backup for 'ubicor'
	| pg_dump: error: connection to server at "database", port 5432 failed: FATAL:  database "ubicor" does not exist
	| 2022-06-29 04:00:00: - Upload 'ubicor' backup to s3
	| 2022-06-29 04:00:00: - Uploaded file: s3://projects-backup-files/databases/ubicor.sql.zip
	| 2022-06-29 04:00:00: 
	| 2022-06-29 04:00:00: - Create backup for 'postgres'
	| 2022-06-29 04:00:00: - Upload 'postgres' backup to s3
	| 2022-06-29 04:00:01: - Uploaded file: s3://projects-backup-files/databases/postgres.sql.zip
	| 2022-06-29 04:00:01: 
	| 2022-06-29 04:00:01: -----------------------------------------
	| 2022-06-29 04:00:01:            PG BACKUP FINISH
	| 2022-06-29 04:00:01: =========================================
	| 2022-06-29 04:00:01:
	| 2022-06-29 04:00:01:
	| 2022-06-29 04:00:01: =========================================
	| 2022-06-29 04:00:01:            FILES BACKUP INIT
	| 2022-06-29 04:00:01: -----------------------------------------
	| 2022-06-29 04:00:01:
	| 2022-06-29 04:00:01: - Upload folder: 'f.zip'
	| 2022-06-29 04:00:02: - Uploaded file: s3://projects-backup-files/static-files/f.zip.zip
	| 2022-06-29 04:00:02: 
	| 2022-06-29 04:00:02: - Upload folder: 'folder1'
	| 2022-06-29 04:00:03: - Uploaded file: s3://projects-backup-files/static-files/folder1.zip
	| 2022-06-29 04:00:03: 
	| 2022-06-29 04:00:03: - Upload folder: 'folder2'
	| 2022-06-29 04:00:04: - Uploaded file: s3://projects-backup-files/static-files/folder2.zip
	| 2022-06-29 04:00:04: 
	| 2022-06-29 04:00:04: -----------------------------------------
	| 2022-06-29 04:00:04:            FILES BACKUP FINISH
	| 2022-06-29 04:00:04: =========================================
	| 2022-06-29 04:00:04:
