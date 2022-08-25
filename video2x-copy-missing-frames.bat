@echo off

rem %1 is the unprocessed files folder
set unprocessed=%1
rem remove double quotes
set unprocessed=%unprocessed:"=%
rem %2 is the processed files folder
set processed=%2
rem remove double quotes
set processed=%processed:"=%
rem %3 is the target files folder
set target=%3
rem remove double quotes
set target=%target:"=%
set /a count = 0
set /a showevery = 100

echo %unprocessed%

for %%f in ("%unprocessed%\*.png") do ( call :test "%processed%\%%~nf.png" "%unprocessed%\%%~nf.png" )

goto exit

:test
rem echo %2
if not exist %1 (
	copy %2 "%target%"		
	echo copied %2
)

set /a mod=count%%showevery
if %mod% == 0 ( 
	echo %count% files tested. 
)
set /a count += 1
goto :eof

:exit
echo Done.
