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
GOTO FORECOPYTEST

:FORECOPYTEST
		
		if exist "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" (GOTO RUNFORECOPY) ELSE (GOTO SKIPPINGFORECOPY)
		
			:RUNFORECOPY
			
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -empgixc "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Using forecopy to copy file may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -empgixc "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
				@echo off
				echo.
				echo Preparing to copy $LogFile
				echo.
				mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\logfile"
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\logfile" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -f "%SYSTEMDRIVE%\$LogFile" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\logfile" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo on
				"%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -f "%SYSTEMDRIVE%\$LogFile" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\logfile" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
				@echo off
				if exist "%WINDIR%\AppCompat\Programs\RecentFileCache.bcf" (
					@echo on
					echo.
					echo Preparing to copy RecentFileCache.bcf
					echo.
					mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\recentfilecache"
					@echo off
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\recentfilecache" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -f "%WINDIR%\AppCompat\Programs\RecentFileCache.bcf" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\recentfilecache" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo on
					"%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -f "%WINDIR%\AppCompat\Programs\RecentFileCache.bcf" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\recentfilecache" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
					@echo off
				)
				if exist "%WINDIR%\AppCompat\Programs\Amcache.hve" (
					@echo on
					echo.
					echo Preparing to copy Amcache.hve
					echo.
					mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\amcache"
					@echo off
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\amcache" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -f "%WINDIR%\AppCompat\Programs\Amcache.hve" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\amcache" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo on
					"%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -f "%WINDIR%\AppCompat\Programs\Amcache.hve" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\amcache" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
					echo off
				)
				if exist "%SYSTEMROOT%\System32\drivers\etc\hosts" (
					@echo on
					echo.
					echo Preparing to copy hosts file
					echo.
					mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\hosts"
					@echo off
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\hosts" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -f "%SYSTEMROOT%\System32\drivers\etc\hosts" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\hosts" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo on
					"%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" -f "%SYSTEMROOT%\System32\drivers\etc\hosts" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\hosts" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
					@echo off
				)			
			
			@echo off
			GOTO ENDOFFORECOPY			
			
			:SKIPPINGFORECOPY
			@echo off
			echo.
			echo Skipping forecopy...
			echo forecopy_handy.exe not found under the path "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe"
			echo Please download the program from https://code.google.com/p/proneer/downloads/list
			echo and save the file to the folder "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo forecopy_handy.exe not found under the path "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from https://code.google.com/p/proneer/downloads/list >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%forecopy\forecopy_handy.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
			GOTO ENDOFFORECOPY


:ENDOFFORECOPY
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"