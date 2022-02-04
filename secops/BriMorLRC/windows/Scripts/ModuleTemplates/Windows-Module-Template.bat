@echo off
REM Last updated DD Month YYYY by [Your Name] ([you@emailaddress])
REM Please read "ReadMe.txt" for more information regarding GPL, the script itself, and changes
REM RELEASE DATE: YYYYMMDD
REM AUTHOR: [Your Name] ([you@emailaddress])
REM TWITTER: [Twitter name] ([@TwitterHandle])
REM Copyright: 2013-YYYY, [Your Name]

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

GOTO [MODULENAME]

:[MODULENAME]
		if exist "%TOOLSCRIPTPATH%[Tool path]" (GOTO RUN[MODULENAME]) ELSE (GOTO SKIPPING[MODULENAME])
		
			:RUN[MODULENAME]
			
			REM We use these line if we are saving the output of an executable or command directly to a text file
			REM For example: netstat -ano >> netstat.txt
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%[Tool path]" [command line arguments] >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo on
			"%TOOLSCRIPTPATH%[Tool path]" [command line arguments] >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\[Output folder]\[Output file name and file extension]" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			
			REM We use these lines if we are saving the output directly to a file, from the executable itself
			REM For example: lastactivityview\LastActivityView.exe" /shtml "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LastActivityView.html"
			
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%[Tool path]" [command line arguments] "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\[Output folder]\[Output file name and file extension]" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo on
			"%TOOLSCRIPTPATH%[Tool path]" [command line arguments] "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\[Output folder]\[Output file name and file extension]" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1				

			@echo off
			GOTO ENDOF[MODULENAME]			
			
			:SKIPPING[MODULENAME]
			@echo off
			echo.
			echo Skipping [Tool name]...
			echo [Executable name] not found under the path "%TOOLSCRIPTPATH%[Tool path]"
			echo Please download the program from [Executable download location, if applicable]
			echo and save the file to the folder "%TOOLSCRIPTPATH%[Tool path]"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo [Executable name] not found under the path "%TOOLSCRIPTPATH%[Tool path]" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from [Executable download location, if applicable] >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%[Tool path]" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
			GOTO ENDOF[MODULENAME]


:ENDOF[MODULENAME]
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"

REM Don't forget to add this module to the batch script(s) that you want to process!!

	REM GOTO [MODULENAME]MODULE
	REM @echo off

REM :[MODULENAME]MODULE
	REM @echo off
	REM CALL "%~dps0%\Windows-Modules\[name of batch script module].bat"
	REM GOTO [NEXT]MODULE
	REM @echo off
		