REM Mark Matthias, Feb 29 2016 leap day
@echo off
echo.
echo USAGE: backup.bat 1 or 0
echo.
echo.  - 1 WILL kill Outlook to allow pst file backup.
echo.  - 0 WON'T kill Outlook
echo.  - Script exits if 0 or 1 param is not provided.
echo.

:: specify top level source directory:
set DOCS=%USERPROFILE%\Documents

set doMail=%1
if [%doMail%]==[] goto ERR1

if %doMail%==1 (
	%DOCS%\support_files\bin\SysinternalsSuite\pskill.exe Outlook.exe
)

:START
REM ++++++++++++++++++++++++++++++++++++++++++++++++++++

:: backup sources.  EDIT name/directory pairs as needed, 
:: then do the same to robocopy commands.

set mail=mail
set a1=support_files
set a2=1-Advantage Test Cases
set a3=2-Advantage External Test Data
set a4=3-Advantage Test Tracking Attempts
set a5=4-Advantage Help
set a6=BackupApp
set a7=bin
set a8=ECO
set a9=Opened Always

REM ++++++++++++++++++++++++++++++++++++++++++++++++++++

:: backup directories .  Be sure subdirectories match the ones set up above.

set SW=/E /R:1 /W:1 /A-:SH /NFL /NDL /LOG+:%userprofile%\roboCopyBackup.log /TEE
set DST=G:\RoboBackups

if %doMail%==1 robocopy %SW% "%DOCS%\%mail%" "%DST%\%mail%"
robocopy %SW% "%DOCS%\%a1%" "%DST%\%a1%"
robocopy %SW% "%DOCS%\%a2%" "%DST%\%a2%"
robocopy %SW% "%DOCS%\%a3%" "%DST%\%a3%"
robocopy %SW% "%DOCS%\%a4%" "%DST%\%a4%"
robocopy %SW% "%DOCS%\%a5%" "%DST%\%a5%"
robocopy %SW% "%DOCS%\%a6%" "%DST%\%a6%"
robocopy %SW% "%DOCS%\%a7%" "%DST%\%a7%"
robocopy %SW% "%DOCS%\%a8%" "%DST%\%a8%"
robocopy %SW% "%DOCS%\%a9%" "%DST%\%a9%"

:: backup files only under DOCS directory
set SW2 = /R:1 /W:1 /A-:SH /NFL /NDL /LOG+:%userprofile%\roboCopyBackup.log /TEE
robocopy %SW2% %DOCS% %DST% *.*

REM ++++++++++++++++++++++++++++++++++++++++++++++++++++
::
:: a new source and DST
set b1=G:\Snagit
set d1=Snagit
set b2=bin
set b3=support_files

set DST2=F:\work

robocopy %SW% "%b1%" "%DST2%\%d1%"
robocopy %SW% "%DOCS%\%b2%" "%DST2%\%b2%"
robocopy %SW% "%DOCS%\%b3%" "%DST2%\%b3%"

goto END

:ERR1
echo.
echo ERROR: Requiried parameter needed: 1 = kill Outlook.exe, 0 = NOT kill Outlook.exe

goto END

:END
echo Done.

:: Switches -->
:: (copyflags : D=Data, A=Attributes, T=Timestamps). (S=Security=NTFS ACLs, O=Owner info, U=aUditing info).
:: /A-:[RASHCNET] :: remove the given Attributes from copied files
:: /DCOPY:DAT --> copies directory data, attributes, and timestamps, we want this.
:: /DCOPY:copyflag[s] :: what to COPY for directories
:: /E :: copy subdirectories, including Empty ones.
:: /LOG+:file :: output status to LOG file (append to existing log)
:: /MON:n :: MONitor source; run again when more than n changes seen.
:: /MOT:m :: MOnitor source; run again in m minutes Time, if changed.
:: /MT[:n] :: Do multi-threaded copies with n threads, default 8.
:: /NDL :: No Directory List - don't log directory names.
:: /NFL :: No File List - don't log file names.
:: /PURGE - delete dest files/dirs that no longer exist in source
:: /S :: copy nonempty subdirs
:: /XD dirs [dirs]... :: eXclude Directories matching given names/paths.

