# Backup and restore Gitlab [Docker]

> Batch files to simplify backing up of gitlab docker containers

`create_gitlab_backup.bat` requries 1 argument, the gitlab container you wish to backup.

Outputs: 
- a folder `\backups` containing the backup tar files
- a folder `\gitlab` containing the gitlab-secrets as well as other gitlab files

`restore_gitlab_backup.bat` folder requires 2 arguments, folder where backup tar files and gitlab secrets are found, followed by the name of the container of the new gitlab instance