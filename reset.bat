@echo off
cls

SET REPO=git@github.com:leekh4232/hossam-blog

IF "%1" == "" (
    SET comment=initialize %DATE% %TIME%
) ELSE (
    SET comment=%1
)

echo $ rmdir /q /s .git
rmdir /q /s .git

echo $ git init
git init

echo $ git branch -M main
git branch -M main

echo $ git remote add origin %REPO%
git remote add origin %REPO%

echo $ git add -A
git add -A

echo $ git commit -m "%comment"
echo ----------------------------------------
git commit -m "%comment"

echo.
echo $ git push --force --set-upstream origin main
echo ----------------------------------------
git push --force --set-upstream origin main

echo.
pause