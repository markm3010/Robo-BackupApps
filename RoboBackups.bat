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
set DOCS=%USERPROFILE%\DOCS

set mailBackup=%1
if [%mailBackup%]==[] goto ERR1

if %mailBackup%==1 (
	%DOCS%\support_files\bin\SysinternalsSuite\pskill.exe Outlook.exe
)

:START
REM ++++++++++++++++++++++++++++++++++++++++++++++++++++

:: backup sources.  EDIT name/directory pairs as needed, 
:: then do the same to robocopy commands.

set adv24testcases=1-Adv 2.4 Test Cases
set ExternalTestData=2-Advantage External Test Data
set AdvantageTstTracking=3-Advantage Test Tracking Attempts
set AdvantageHelp=4-Advantage Help
set backupapp=BackupApp
set bin=bin
set eco=ECO
set mail=mail
set notes2015=Notes_2015
set openedalways=Opened Always
set supportfiles=support_files
set 

REM ++++++++++++++++++++++++++++++++++++++++++++++++++++

:: backup directories .  Be sure subdirectories match the ones set up above.

set DIRSWITCH=/E /R:1 /W:1 /A-:SH /NFL /NDL /LOG+:%userprofile%\roboCopyBackup.log /TEE
set DESTINATION=G:\RoboBackups

robocopy %DIRSWITCH% "%DOCS%\%adv24testcases%" "%DESTINATION%\%adv24testcases%"
robocopy %DIRSWITCH% "%DOCS%\%ExternalTestData%" "%DESTINATION%\%ExternalTestData%"
robocopy %DIRSWITCH% "%DOCS%\%AdvantageTstTracking%" "%DESTINATION%\%AdvantageTstTracking%"
robocopy %DIRSWITCH% "%DOCS%\%AdvantageHelp%" "%DESTINATION%\%AdvantageHelp%"
robocopy %DIRSWITCH% "%DOCS%\%backupapp%" "%DESTINATION%\%backupapp%"
robocopy %DIRSWITCH% "%DOCS%\%bin%" "%DESTINATION%\%bin%"
robocopy %DIRSWITCH% "%DOCS%\%eco%" "%DESTINATION%\%eco%"
if %mailBackup%==1 robocopy %DIRSWITCH% "%DOCS%\%mail%" "%DESTINATION%\%mail%"
robocopy %DIRSWITCH% "%DOCS%\%notes2015%" "%DESTINATION%\%notes2015%"
robocopy %DIRSWITCH% "%DOCS%\%openedalways%" "%DESTINATION%\%openedalways%"
robocopy %DIRSWITCH% "%DOCS%\%supportfiles%" "%DESTINATION%\%supportfiles%"

REM ++++++++++++++++++++++++++++++++++++++++++++++++++++

:: backup files only under DOCS directory
set FILESWITCH = /R:1 /W:1 /A-:SH /NFL /NDL /LOG+:%userprofile%\roboCopyBackup.log /TEE
robocopy %FILESWITCH% %DOCS% %DESTINATION% *.*

REM ++++++++++++++++++++++++++++++++++++++++++++++++++++
:: a new source and destination
set snagitSrc=G:\Snagit
set snagitDir=Snagit
set DEST2=F:\work

robocopy %DIRSWITCH% "%snagitSrc%" "%DEST2%\%snagitDir%"
robocopy %DIRSWITCH% "%DOCS%\%bin%" "%DEST2%\%bin%"
robocopy %DIRSWITCH% "%DOCS%\%supportfiles%" "%DEST2%\%supportfiles%"

goto END

REM ++++++++++++++++++++++++++++++++++++++++++++++++++++

:ERR1
echo.
echo ERROR: Requiried input needed: 1 to kill Outlook.exe, 0 to NOT kill it.

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

