@echo off

@REM input checks
if [%1]==[] goto usage
if [%2]==[] goto usage

@REM initialise variables
set backup_repo=%1
echo You have provided backup repository as: %backup_repo%

set new_gitlab_containername=%2

@REM check for existing container name
docker ps --format "{{.Names}}"

@REM copying backup
echo copying backup to new container %new_gitlab_containername%

@REM get latest backup file
for /f "tokens=*" %%a in ('dir /A:-D /B /O:-D /S %backup_repo%\backups') do set NEWEST_GITLAB_BACKUP=%%a
echo Backing up from the latest backup file: %NEWEST_GITLAB_BACKUP%

@REM copy latest backup gitlab tar file into container
docker cp %NEWEST_GITLAB_BACKUP% %new_gitlab_containername%:/var/opt/gitlab/backups

@REM stop services connected to database
echo stopping services connected to database
docker exec %new_gitlab_containername% gitlab-ctl stop puma
docker exec %new_gitlab_containername% gitlab-ctl stop sidekiq

@REM Verify that the processes are all down before continuing
echo view statuses
docker exec %new_gitlab_containername% gitlab-ctl status

@REM restore gitlab
echo restore gitlab backup now
docker exec -e GITLAB_ASSUME_YES=1  %new_gitlab_containername% gitlab-backup restore 

@REM gitlab secrets
echo copying gitlab secrets
docker cp %backup_repo%\gitlab\gitlab-secrets.json %new_gitlab_containername%:/etc/gitlab/
@REM docker cp %backup_repo%\gitlab\gitlab.rb %new_gitlab_containername%:/etc/gitlab/

timeout /t 5

@echo on
@REM docker container sould restart automatically once stopped
docker stop %new_gitlab_containername% 

@REM sleep for 10 seconds
timeout /t 30

@REM check gitlab
@REM docker exec -it %new_gitlab_containername% gitlab-rake gitlab:check SANITIZE=true

echo Wait for a while and gitlab should be up!

goto:eof
:usage
@echo Usage: Please specify arguments <folder to backup from> and <name of new running gitlab container>
exit /B 1