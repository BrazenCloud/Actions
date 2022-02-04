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

GOTO WMICDISKCOLLECTION
:WMICDISKCOLLECTION

if exist "%WINDIR%\system32\wbem\WMIC.exe" (GOTO WMICINSTALLED) ELSE (GOTO WMICNOTINSTALLED)
	:WMICINSTALLED
	
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" diskdrive list brief /format:list >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" /output:"%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\DiskDriveList_wmic.txt" diskdrive list brief /format:list 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=0 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=0 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=1 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=1 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=2 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=2 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=3 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=3 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=5 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=5 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=0 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=0 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=1 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=1 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=2 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=2 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=3 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=3 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=5 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%WINDIR%\system32\wbem\WMIC.exe" logicaldisk where drivetype=5 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		
		@echo off

		GOTO ENDOFDISKSIZES

	:WMICNOTINSTALLED
	IF %TypeOfOS% EQU 64 (GOTO 64BITWMICNOTINSTALLED) ELSE (GOTO 32BITWMICNOTINSTALLED)
	
	:64BITWMICNOTINSTALLED
	
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" diskdrive list brief /format:list >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" /output:"%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\DiskDriveList_wmic.txt" diskdrive list brief /format:list 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=0 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=0 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=1 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=1 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=2 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=2 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=3 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=3 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=5 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=5 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=0 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=0 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=1 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=1 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=2 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=2 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=3 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=3 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=5 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC\WMIC.exe" logicaldisk where drivetype=5 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
				
		
		@echo off
		GOTO ENDOFDISKSIZES

	:32BITWMICNOTINSTALLED
	
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" diskdrive list brief /format:list >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" /output:"%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\DiskDriveList_wmic.txt" diskdrive list brief /format:list 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=0 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=0 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=1 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=1 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=2 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=2 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=3 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=3 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=5 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=5 get name >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=0 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=0 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=1 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=1 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=2 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=2 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=3 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=3 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=5 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo on
		"%TOOLSCRIPTPATH%WMIC32\WMIC.exe" logicaldisk where drivetype=5 get size, caption >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		
		@echo off
		GOTO ENDOFDISKSIZES

:ENDOFDISKSIZES
	@echo off
	echo.
	echo ***** Module "%~nx0" has completed. *****
	echo ***** Returning to %MAINSCRIPTNAME% *****
	echo.
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"