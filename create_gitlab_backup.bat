@echo off

@REM get current date
@REM for /F "tokens=2" %%i in ('date /t') do set mydate=%%i

@REM @REM get current time 
@REM set mytime=%time%

@REM @REM convert all slashes to dash
@REM set "mydate=%mydate:/=-%"

@REM set "mytime=%mytime::=-%"
@REM set "mytime=%mytime:.=-%"

@REM set "uniquetime=%mydate%-%mytime%"

@REM echo Current time is %uniquetime%

@REM set foldername="D:\gitlabstuff\backup%uniquetime%"


@REM 
@echo off

if [%1]==[] goto usage
@echo Arguments given


set foldername="D:\gitlabstuff\backup"
echo Making folder %foldername%
mkdir %foldername%

@REM Create backup for existing gitlab container
set original_gitlab_container=%1
echo You chose container %original_gitlab_container%

docker exec -t %original_gitlab_container% gitlab-backup create

@REM copy backup to local folder
docker cp %original_gitlab_container%:/var/opt/gitlab/backups %foldername%

@REM copy config files
docker cp %original_gitlab_container%:/etc/gitlab/ %foldername%

@REM done
echo backup complete at %foldername%
echo You must now create a new docker instance and attach it to given docker volume

goto:eof
:usage
@echo Usage: Please specify argument of name of the gitlab container
exit /B 1
