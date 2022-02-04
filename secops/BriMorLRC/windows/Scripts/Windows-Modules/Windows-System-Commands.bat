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
GOTO WINDOWSSYSTEMCOMMANDS

:WINDOWSSYSTEMCOMMANDS
		
	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: chcp >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	@echo on
	chcp >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Windows_codepage.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: dir /S /O-D "%HOMEDRIVE%\" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo.
	echo Performing a full file listing may take a few minutes. Please be patient...
	@echo on
	dir /S /O-D "%HOMEDRIVE%\" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Full_file_listing.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: findstr /L ? "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Full_file_listing.txt" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	@echo on
	findstr /L ? "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Full_file_listing.txt" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Possible_unicode_files_and_directories.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: dir /S /B /AHD "%HOMEDRIVE%\" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo.
	echo Searching for hidden directories may take a few minutes. Please be patient...
	@echo on
	dir /S /B /AHD "%HOMEDRIVE%\" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\List_hidden_directories.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: ver >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	@echo on
	ver >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Windows_Version.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: systeminfo >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	@echo on
	systeminfo >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\system_info.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: time/T >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	@echo on
	time/T >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\system_date_time_tz.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: date/T >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	@echo on
	date/T >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\system_date_time_tz.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: w32tm /tz >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	@echo on
	w32tm /tz >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\system_date_time_tz.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: schtasks /query /fo LIST /v >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo.
	echo Gathering scheduled tasks may take a few minutes. Please be patient...
	@echo on
	schtasks /query /fo LIST /v >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\scheduled_tasks.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: tasklist /V >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo.
	echo Gathering running processes may take a few minutes. Please be patient...
	@echo on
	tasklist /V >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Running_processes.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: tasklist /M >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo.
	echo Gathering loaded dlls may take a few minutes. Please be patient...
	@echo on
	tasklist /M >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\Loaded_dlls.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo Command Run: tasklist /SVC >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo.
	echo Gathering services associated with processes may take a few minutes. Please be patient...
	@echo on
	tasklist /SVC >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\services_aw_processes.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

	@echo off
	GOTO ENDOFWINDOWSSYSTEMCOMMANDS
		
:ENDOFWINDOWSSYSTEMCOMMANDS
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	