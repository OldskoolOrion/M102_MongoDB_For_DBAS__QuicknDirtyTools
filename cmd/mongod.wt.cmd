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
SET lpath=D:\Development\MongoDB307.x64\log.wt\
SET lnfixedpart=_mongod.wt.logfile
SET lfile=%lpath%%ldt%%lnfixedpart%

mongod.exe --port 38028 --storageEngine wiredTiger --dbpath D:\Development\MongoDB307.x64\data.wt -vv | mtee %lfile%

:: without the extra logging script, we could e.g. start the database-server with just a few alterations on the commandline, since it's just for testing and study purposes :
:: - on a different port than the MMAPv1-se-DBserver, so both servers can run simultaneous (free port randomly chose) : port 38028
:: - a different data-directory - again to keep things tidy and seperated                                             : D:\_Development_\MongoDB307.x64\data.wt
:: - a different log-directory  - same reason as above                                                                : D:\_Development_\MongoDB307.x64\log.wt
::
:: mongod.exe --port 38028 --storageEngine wiredTiger --dbpath D:\_Development_\MongoDB307.x64\data.wt --logpath D:\_Development_\MongoDB307.x64\log.wt\mongod.wt.logfile
::
:: the logging-version of the simple mongod-startup script, has been modified accordingly above
:: new simple shell-startup script added : start the shell on the correct port (with optional parameters) by issueing : mongo.wt [arg1, arg2, ...]
