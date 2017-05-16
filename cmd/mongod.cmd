:: Needs ported Unix-command 'tee' for logging to STDOUT && timestamped log-file simultaneous.
:: Find a lightweight Unix-tools for Windows package for instance here : https://github.com/bmatzelle/gow/wiki
:: I prefer this package over the bloated CygWin binaries-tree.. install && add Gow\bin-dir to path.
:: Simpel quick script utilizing 'wimc' to ensure localized date-time format for timestamping.
:: No spaces in filenames & paths, so I don't need to bother dealing with them.
:: the multiple -v's set more verbosity level : goes up to 5 (?) : probably way too much logging!
::
:: I found a fine new windows version of an tee-alike utility called MTEE v2.21 by Ritchie Lawrence
:: find it at http://www.commandline.co.uk - it's being maintained and works for Windows XP .. 10 !
::
:: I am using it myself since it has a lot more functionality than the old GNU tools for windows variants.
:: Therefore I adjusted the final line of this script, to use MTEE instead of TEE (see below).

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
FOR /f "usebackq tokens=1,2 delims==" %%i IN (`wmic os get LocalDateTime /VALUE 2^>NUL`) DO IF '.%%i.'=='.LocalDateTime.' SET ldt=%%j

SET ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%_%ldt:~8,2%.%ldt:~10,2%.%ldt:~12,6%
SET lpath=D:\Development\MongoDB307.x64\log\
SET lnfixedpart=_mongod.logfile
SET lfile=%lpath%%ldt%%lnfixedpart%

mongod.exe --smallfiles --noprealloc --dbpath D:\Development\MongoDB307.x64\data -vv | mtee %lfile%
