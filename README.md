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
	        build: automate-backups-to-s3
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
