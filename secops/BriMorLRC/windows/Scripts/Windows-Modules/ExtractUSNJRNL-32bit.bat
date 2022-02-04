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
GOTO TESTEXTRACTUSN

	:TESTEXTRACTUSN	
		if exist "%TOOLSCRIPTPATH%ExtractUsnJrnl\ExtractUsnJrnl.exe" (GOTO RUNEXTRACTUSN32) ELSE (GOTO SKIPPINGEXTRACTUSN32)

		:RUNEXTRACTUSN32
			@echo on
			mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\usnjrnl"
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\usnjrnl" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%ExtractUsnJrnl\ExtractUsnJrnl.exe" %SYSTEMDRIVE% "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\usnjrnl" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo on
			"%TOOLSCRIPTPATH%ExtractUsnJrnl\ExtractUsnJrnl.exe" %SYSTEMDRIVE% "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\usnjrnl" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
			
			@echo off
			GOTO ENDOFEXTRACTUSN32		
			
			:SKIPPINGEXTRACTUSN32
			@echo off
			echo.
			echo Skipping extraction of USNJournal File...
			echo ExtractUsnJrnl.exe not found under the path "%TOOLSCRIPTPATH%ExtractUsnJrnl\ExtractUsnJrnl.exe"
			echo Please download the program from https://github.com/jschicht/ExtractUsnJrnl
			echo and save the file to the folder "%TOOLSCRIPTPATH%ExtractUsnJrnl\ExtractUsnJrnl.exe"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo ExtractUsnJrnl.exe not found under the path "%TOOLSCRIPTPATH%ExtractUsnJrnl\ExtractUsnJrnl.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from https://github.com/jschicht/ExtractUsnJrnl >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%ExtractUsnJrnl\ExtractUsnJrnl.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"					
			GOTO ENDOFEXTRACTUSN32

:ENDOFEXTRACTUSN32
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		