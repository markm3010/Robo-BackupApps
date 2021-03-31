@echo off

echo.
set SRC1=C:\Users\mattmart\Documents
echo SRC1:  %SRC1%
set DESTPREFIX=G:\backups75QJR22ROBO
set DEST1=%DESTPREFIX%\Documents
echo DEST1: %DEST1%

echo Continue? (Ctrl-C to exit)
echo.
pause

if not exist "%DEST1%"  (
	md "%DEST1%"
)
robocopy %SRC1% %DEST1% /E /MIR /NP /TS /LOG+:%DESTPREFIX%\%~n0.log /TEE
