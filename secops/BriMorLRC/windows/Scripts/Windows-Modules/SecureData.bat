@echo off

REM Last updated 05 September 2019 by Brian Moran (brian@brimorlabs.com)
REM Please read "ReadMe.txt" for more information regarding GPL, the script itself, and changes
REM RELEASE DATE: 20190905
REM AUTHOR: Brian Moran (brian@brimorlabs.com)
REM TWITTER: BriMor Labs (@BriMorLabs)
REM Version: Live Response Collection (Cedarpelta Build - 20190905)
REM Copyright: 2013-2019, Brian Moran

REM This file is part of the Live Response Collection
REM The Live Response Collection is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
REM This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
REM You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
REM Additionally, usages of all tools fall under the express license agreement stated by the tool itself.

SET SEVENZIPRAN=0
@echo off
echo.
echo *****Running module "%~nx0" now*****
echo.
GOTO SECUREZIP

:SECUREZIP
	if exist "%TOOLSCRIPTPATH%7zip\7z.exe" (GOTO RUNSZIP) ELSE (GOTO SKIPPINGSZIP)
		:RUNSZIP
			@echo off
			echo.
			echo The program will now use 7-zip to compress and password protect your data with the password %SECUREPASSWORD%
			echo If you do not copy %SECUREPASSWORD% there will be no way to open the collected data
			echo.
			SET SEVENZIPRAN=1
			echo on
			"%TOOLSCRIPTPATH%7zip\7z.exe" a "%TRIMMEDSCRIPTPATH%%computername%%dt%.7z" "%TRIMMEDSCRIPTPATH%%computername%%dt%\*" -p%SECUREPASSWORD%	
			@echo off
			GOTO SECUREDELETE

		:SKIPPINGSZIP
			@echo off
			echo.
			echo Skipping 7zip...
			echo 7z.exe not found under the path "%TOOLSCRIPTPATH%7zip\7z.exe"
			echo Please download the 7zip program from http://www.7-zip.org/
			echo and extract the files to the folder "%TOOLSCRIPTPATH%7zip"
			echo.
			echo Since 7z.exe cannot be found, this program will skip the rest
			echo of the secure delete module.
			GOTO ENDOFSECUREDATA
			
		
:SECUREDELETE

	if exist "%TOOLSCRIPTPATH%sdelete\sdelete.exe" (GOTO RUNSDELETE) ELSE (GOTO SKIPPINGSDELETE)
		:RUNSDELETE
			echo.
			echo Preparing to securely delete unencrypted gathered data using sdelete.
			echo SDelete will run multiple times per folder in an effort to delete all files and folders.
			echo.
			echo Querying to see if Sysinternals SecureDelete EULA is already accepted on system...
			echo If the value does not exist, you will see an "ERROR" message in the
			echo command prompt window. This is normal.
			echo.
			REG QUERY HKCU\SOFTWARE\Sysinternals\SDelete /v EulaAccepted
			IF %errorlevel%==1 (
				echo.
				echo Registry entry for SDelete EULA not found. The SDelete folder will be deleted upon completion 
				echo.
				@echo on
				"%TOOLSCRIPTPATH%sdelete\sdelete.exe" /accepteula -p 5 -q -s -r "%TRIMMEDSCRIPTPATH%%computername%%dt%"		
				"%TOOLSCRIPTPATH%sdelete\sdelete.exe" /accepteula -p 5 -q -s -r "%TRIMMEDSCRIPTPATH%%computername%%dt%"
				"%TOOLSCRIPTPATH%sdelete\sdelete.exe" /accepteula -p 5 -q -s -r "%TRIMMEDSCRIPTPATH%%computername%%dt%"
				@echo off
				REG DELETE "HKCU\Software\Sysinternals\SDelete" /f
				GOTO ENDOFSECUREDATA
			)
			echo Registry entry for SecureDelete EULA found. The SDelete folder will NOT be deleted upon completion.
			echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
			echo.
			REG ADD "HKCU\Software\Sysinternals\SDelete" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
			@echo on
				"%TOOLSCRIPTPATH%sdelete\sdelete.exe" /accepteula -p 5 -q -s -r "%TRIMMEDSCRIPTPATH%%computername%%dt%"		
				"%TOOLSCRIPTPATH%sdelete\sdelete.exe" /accepteula -p 5 -q -s -r "%TRIMMEDSCRIPTPATH%%computername%%dt%"
				"%TOOLSCRIPTPATH%sdelete\sdelete.exe" /accepteula -p 5 -q -s -r "%TRIMMEDSCRIPTPATH%%computername%%dt%"
			@echo off
			GOTO ENDOFSECUREDATA

		:SKIPPINGSDELETE
			@echo off
			echo.
			echo Skipping sdelete...
			echo sdelete.exe not found under the path "%TOOLSCRIPTPATH%sdelete\sdelete.exe"
			echo Please download the file SDelete.zip from https://technet.microsoft.com/en-us/sysinternals/bb897443.aspx
			echo and extract the files to the folder "%TOOLSCRIPTPATH%sdelete"
			echo.	
			echo sdelete.exe not found under the path "%TOOLSCRIPTPATH%sdelete\sdelete.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt"
			echo Please download the file SDelete.zip from https://technet.microsoft.com/en-us/sysinternals/bb897443.aspx >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt"
			echo and extract the files to the folder "%TOOLSCRIPTPATH%sdelete" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt"			
			GOTO ENDOFSECUREDATA
			
:ENDOFSECUREDATA
	IF %SEVENZIPRAN% EQU 0 (GOTO SEVENZIPDIDNOTRUN) ELSE (GOTO LASTCHANCE)
	:LASTCHANCE
		@echo off
		echo This is your last chance to ensure that you copied %SECUREPASSWORD%
		echo Remember if you do not copy %SECUREPASSWORD% you will not be able to open the gathered data!
		echo.
		pause
		echo.
		echo.
		echo One more last chance. Copy %SECUREPASSWORD% or you will not be able to open the gathered data!
		echo.
		pause
		echo off
		GOTO RETURNINGTOSCRIPT
	:SEVENZIPDIDNOTRUN
		@echo off
		echo.  >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt"
		echo 7z.exe not found under the path "%TOOLSCRIPTPATH%7zip\7z.exe"  >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt"
		echo Please download the 7zip program from http://www.7-zip.org/  >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt"
		echo and extract the files to the folder "%TOOLSCRIPTPATH%7zip"  >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt"
		echo off
		GOTO RETURNINGTOSCRIPT		
		
:RETURNINGTOSCRIPT
	echo.
	echo ***** Module "%~nx0" has completed. *****
	echo ***** Returning to %MAINSCRIPTNAME% *****
	echo.