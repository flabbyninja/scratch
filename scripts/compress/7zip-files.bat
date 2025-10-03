@REM Find all directories under current path. Create a separate, max compressed and encrypted ZIP containing the contents
@REM Usage: 7zip-files.bat <password>
@ECHO OFF

if [%1%] == [] (
  echo Password not specified
  echo Usage: %0% <password>
  exit /b 1
)

set APP_NAME="C:\Program Files\7-Zip\7z.exe"
set PARAMS=-mx9 -mhe=on -p%1%


for /D %%d in (*.*) do %APP_NAME% a %PARAMS% %%d.7z %%d
