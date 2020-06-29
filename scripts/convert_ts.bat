%~d1
set EMBY_LOC=c:\tools\emby
CD "%~dp1"
for /r %%F in (*.ts) do (
%%~dF
CD "%%~dpF"
rem %EMBY_LOC%\system\ffmpeg.exe -f lavfi -i "movie='%%~nxF'[out0+subcc]" -map s "%%~nF.eng.srt"
%EMBY_LOC%\system\ffmpeg.exe -fflags +genpts -i "%%F" -c:v copy -c:a aac "%%~nF.mp4"
if not errorlevel 1 if exist "%%~dpnF.mp4" del /q "%%F"
)