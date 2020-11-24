::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWH3eyHcjLQlHcBeXKXi/FIk47fvw++WXnn4oFNoTS8/4+4CyJOkA6UnlfJsoxDRQiMxs
::fBE1pAF6MU+EWH3eyHcjLQlHcBeXKXi/FIk47fvw++WXnn4oFNoTS8/4+4CyLO8U5Qv0e5FN
::fBE1pAF6MU+EWH3eyE88IAJNQDiEOmaqA7Ig6uH10+yBr10YU6w6YIq7
::fBE1pAF6MU+EWH3eyE88IAJNQDiEOmaqA7Ig6uH10+yBsl8SVudxfZfeug==
::YAwzoRdxOk+EWAjk
::fBw5plQjdCuDJGyX8VAjFAhBWReHLleeCaIS5Of66/m7q04SWqw2e4C7
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF25
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZksaHGQ=
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRmG7QIdLRddRES7PXK2omR8
::Zh4grVQjdCuDJGyX8VAjFAhBWReHLleeA6YX/Ofr09my4nUxZ6IcWbvn3rqKbeMc5FPhZ4Jj02Jf+A==
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@ECHO OFF
ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate %1 > fps.txt
set /P fpsRaw=<fps.txt
if %fpsRaw%==24000/1001 goto 23976
if %fpsRaw%==30000/1001 goto 2997
if %fpsRaw%==24/1 goto 24
if %fpsRaw%==25/1 goto 25
if %fpsRaw%==30/1 goto 30
goto uncommon

:23976
set fps=23.976
set discFrames=360
goto main
:2997
set fps=29.97
set discFrames=450
goto main
:24
set fps=24
set discFrames=360
goto main
:25
set fps=25
set discFrames=375
goto main
:30
set fps=30
set discFrames=450
goto main

:main
del fps.txt
:setStart
cls
set /P start="Trim until at beginning (hh:mm:ss):" 
set delimit1 =%start:~2,-5%
set delimit2 =%start:~5,-2%

for /F "tokens=1,2,3 delims=:" %%a in ("%start%") do (
   for /F "tokens=* delims=0" %%a in ("%%a") do (
      set "startHour=%%a" & set /A "startHour+=0"
   )
   for /F "tokens=* delims=0" %%b in ("%%b") do (
      set "startMin=%%b" & set /A "startMin+=0"
   )
   for /F "tokens=* delims=0" %%c in ("%%c") do (
      set "startSec=%%c" & set /A "startSec+=0"
   )
)

echo(%startHour%|findstr "^[0-5]*$  ^0$">nul&&echo.||goto timeErrorStart
echo(%startMin%|findstr "^[0-5][0-9]*$  ^0$">nul&&echo.||goto timeErrorStart
echo(%startSec%|findstr "^[0-5][0-9]*$  ^0$">nul&&echo.||goto timeErrorStart

:setEnd
set /P end="Trim at end beginning at (hh:mm:ss):"
set delimit3 =%end:~2,-5%
set delimit4 =%end:~5,-2%

for /F "tokens=1,2,3 delims=:" %%a in ("%end%") do (
   for /F "tokens=* delims=0" %%a in ("%%a") do (
      set "endHour=%%a" & set /A "endHour+=0"
   )
   for /F "tokens=* delims=0" %%b in ("%%b") do (
      set "endMin=%%b" & set /A "endMin+=0"
   )
   for /F "tokens=* delims=0" %%c in ("%%c") do (
      set "endSec=%%c" & set /A "endSec+=0"
   )
)

echo(%endHour%|findstr "^[0-5]*$  ^0$">nul&&echo.||goto timeErrorEnd
echo(%endMin%|findstr "^[0-5][0-9]*$  ^0$">nul&&echo.||goto timeErrorEnd
echo(%endSec%|findstr "^[0-5][0-9]*$  ^0$">nul&&echo.||goto timeErrorEnd


set /a durationStart=(%startHour% * 3600) + (%startMin% * 60) + (%startSec%)
set /a durationEnd=(%endHour% * 3600) + (%endMin% * 60) + (%endSec%)
set /a duration=%durationEnd% - %durationStart%
set /a durationFadeOut=%duration%-1

if %duration% LEQ 5 echo Invalid timecodes provided && goto setStart

:noTimeError
set outputFilename=%1
for /r %%f in (%outputFilename%) do (
   set outputFilename=%%~nxf
)
set outputFilename=%outputFilename:"=%

rem for /F "tokens=* delims=/" %%a in ("%fpsRaw%") do (
rem   set /A "fps=1000*%%a" & set /A "fps+=0"
rem   set /A "discFrames=15000*%%a" & set /A "discFrames+=0"
rem )
rem set fps=%fps:~0,-3%.%fps:~-3%
rem set /A "discFrames=discFrames / 1000"






CHOICE /C OB /N /M "Is audio coming out only from one channel or both? [o = only one, b = both]"
IF %ERRORLEVEL% == 1 goto onechannel
IF %ERRORLEVEL% == 2 goto bothchannel

:bothchannel
set fcmd=ffmpeg -i %1 -i logo.png -i disclaimer.jpg -f lavfi -t 1 -i anullsrc -filter_complex "[2:v]fps=fps=%fpsRaw%,loop=loop=%discFrames%:size=%fpsRaw%:start=0[v2];[v2]fade=t=in:st=0:d=1,fade=t=out:st=14:d=1[vv2];[0:v]trim=start=%durationStart%:end=%durationEnd%,setpts=PTS-STARTPTS,scale=1920:1080,setdar=16/9[v0];[0:a]atrim=start=%durationStart%:end=%durationEnd%,asetpts=PTS-STARTPTS[a0];[v0][1:v]overlay=0:0[vv0];[vv0]fade=t=in:st=0:d=1,fade=t=out:st=%durationFadeOut%:d=1[vvv0];[a0]afade=t=in:st=0:d=1,afade=t=out:st=%durationFadeOut%:d=1[aa0];[vv2][3:a][vvv0][aa0]concat=n=2:v=1:a=1[vv][aa]" -map [vv] -map [aa] -c:a aac -vcodec libx264 -s 1920x1080 "out.%outputFilename%"

%fcmd%
												
goto end

:onechannel
set fcmd=ffmpeg -i %1 -i logo.png -i disclaimer.jpg -f lavfi -t 1 -i anullsrc -filter_complex "[2:v]fps=fps=%fpsRaw%,loop=loop=%discFrames%:size=%fpsRaw%:start=0[v2];[v2]fade=t=in:st=0:d=1,fade=t=out:st=14:d=1[vv2];[0:v]trim=start=%durationStart%:end=%durationEnd%,setpts=PTS-STARTPTS,scale=1920:1080,setdar=16/9[v0];[0:a]atrim=start=%durationStart%:end=%durationEnd%,asetpts=PTS-STARTPTS[a0];[v0][1:v]overlay=0:0[vv0];[vv0]fade=t=in:st=0:d=1,fade=t=out:st=%durationFadeOut%:d=1[vvv0];[a0]afade=t=in:st=0:d=1,afade=t=out:st=%durationFadeOut%:d=1[aa0];[vv2][3:a][vvv0][aa0]concat=n=2:v=1:a=1[vv][aa]" -map [vv] -map [aa] -c:a aac -vcodec libx264 -s 1920x1080 temp.mp4	
												
%fcmd%

set fcmd2=ffmpeg -i temp.mp4 -c:v copy -ac 1 "out.%outputFilename%"

%fcmd2%

del temp.mp4

goto end

:timeErrorStart
echo Error in provided timecode.
goto setStart

:timeErrorEnd
echo Error in provided timecode.
goto setEnd

:uncommon
echo Uncommon frame rate. Program exiting.

:end
pause

