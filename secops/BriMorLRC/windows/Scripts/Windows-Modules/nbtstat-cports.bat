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

@echo off
echo.
echo *****Running module "%~nx0" now*****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo *****Running module "%~nx0" now***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
GOTO NBTSTATCPORTS

:NBTSTATCPORTS

if %TypeOfOS% EQU 64 (GOTO 64BITNBTSTATANDCPORTS) ELSE (GOTO 32BITNBTSTATANDCPORTS)

	:64BITNBTSTATANDCPORTS

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\sysnative\nbtstat.exe" -c >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\sysnative\nbtstat.exe" -c >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\nbtstat.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\sysnative\nbtstat.exe" -S >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\sysnative\nbtstat.exe" -S >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\NetBIOS_sessions.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		GOTO 64BITCPORTS
		
		:64BITCPORTS
		@echo off
		
		if exist "%TOOLSCRIPTPATH%cports-x64\cports.exe" (GOTO RUN64BITCPORTS) ELSE (GOTO SKIPPING64BITCPORTS)
		
			:RUN64BITCPORTS
			
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%cports-x64\cports.exe" /shtml "" /sort 1 /sort ~"Remote Address" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo on
			"%TOOLSCRIPTPATH%cports-x64\cports.exe" /shtml "" /sort 1 /sort ~"Remote Address" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\cports.html" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			
			@echo off
			GOTO ENDOFNBTSTATCPORTS
			
			:SKIPPING64BITCPORTS
			@echo off
			echo.
			echo Skipping cports...
			echo cports.exe not found under the path "%TOOLSCRIPTPATH%cports-x64\cports.exe"
			echo Please download the program from http://www.nirsoft.net/utils/cports.html
			echo and save the file to the folder "%TOOLSCRIPTPATH%cports-x64\cports.exe"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo cports.exe not found under the path "%TOOLSCRIPTPATH%cports-x64\cports.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from http://www.nirsoft.net/utils/cports.html >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%cports-x64\cports.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"			
			GOTO ENDOFNBTSTATCPORTS


	:32BITNBTSTATANDCPORTS

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: nbtstat -c >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		nbtstat -c >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\nbtstat.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: nbtstat -S >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		nbtstat -S >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\NetBIOS_sessions.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		
		@echo off
		GOTO 32BITCPORTS
		
		:32BITCPORTS
		@echo off
		
		if exist "%TOOLSCRIPTPATH%cports\cports.exe" (GOTO RUN32BITCPORTS) ELSE (GOTO SKIPPING32BITCPORTS)
		
			:RUN32BITCPORTS
			
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%cports\cports.exe" /shtml "" /sort 1 /sort ~"Remote Address" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo on
			"%TOOLSCRIPTPATH%cports\cports.exe" /shtml "" /sort 1 /sort ~"Remote Address" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\cports.html" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			
			@echo off
			GOTO ENDOFNBTSTATCPORTS
			
			:SKIPPING32BITCPORTS
			@echo off
			echo.
			echo Skipping cports...
			echo cports.exe not found under the path "%TOOLSCRIPTPATH%cports\cports.exe"
			echo Please download the program from http://www.nirsoft.net/utils/cports.html
			echo and save the file to the folder "%TOOLSCRIPTPATH%cports\cports.exe"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo cports.exe not found under the path "%TOOLSCRIPTPATH%cports\cports.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from http://www.nirsoft.net/utils/cports.html >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%cports\cports.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"		
			GOTO ENDOFNBTSTATCPORTS		


:ENDOFNBTSTATCPORTS
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		