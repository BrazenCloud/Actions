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
GOTO AMPDBNAMES

:AMPDBNAMES
		echo.
		echo Testing to ensure AMP databases are present
		echo. 
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo ***Testing to ensure AMP databases are present >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		if exist "%ProgramW6432%\Cisco\AMP\history.db" (GOTO RUNAMPDBCOPY) ELSE (GOTO SKIPPINGAMPDBCOPY)
		
			:RUNAMPDBCOPY
				if %TypeOfOS% EQU 64 (GOTO 64BITAMPDBCOPY) ELSE (GOTO 32BITAMPDBCOPY)
				
				:64BITAMPDBCOPY
					if exist "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" (GOTO RUNAMPDB64COPY) ELSE (GOTO SKIPPINGAMPDB64COPY)
					
					:RUNAMPDB64COPY
						echo Preparing to copy AMPDB Files
						echo.
						mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\AMP-db"
						@echo off
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\AMP-db" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						REM We run a loop to determine the name of EACH file
						for /F "tokens=*" %%d in ('dir "%ProgramW6432%\Cisco\AMP\*.db*" /b') do call :COPY64AMPDB %ProgramW6432%\Cisco\AMP\%%d
						GOTO ENDOFAMPDBCOPY
						:COPY64AMPDB
							SET AMPDBFILETOCOPY=%*
							echo Command Run: "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" "%AMPDBFILETOCOPY%" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\AMP-db" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
							@echo on
							"%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" "%AMPDBFILETOCOPY%" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\AMP-db" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
							@echo off
							exit /b
							
					:SKIPPINGAMPDB64COPY
						@echo off
						echo.
						echo Skipping copying of AMP related databases...
						echo RawCopy64.exe not found under the path "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe"
						echo Please download the program from https://github.com/jschicht
						echo and save the file to the folder "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe"
						echo.
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo RawCopy64.exe not found under the path "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Please download the program from https://github.com/jschicht >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo and save the file to the folder "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
						GOTO ENDOFAMPDBCOPY						
						
					
				:32BITAMPDBCOPY
					if exist "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" (GOTO RUNAMPDB32COPY) ELSE (GOTO SKIPPINGAMPDB32COPY)
					
					:RUNAMPDB32COPY
						echo Preparing to copy AMPDB Files
						echo.
						mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\AMP-db"
						@echo off
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\AMP-db" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						REM We run a loop to determine the name of EACH file
						for /F "tokens=*" %%d in ('dir "%ProgramW6432%\Cisco\AMP\*.db*" /b') do call :COPY32AMPDB %ProgramW6432%\Cisco\AMP\%%d
						GOTO ENDOFAMPDBCOPY
						:COPY32AMPDB
							SET AMPDBFILETOCOPY=%*
							echo Command Run: "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" "%AMPDBFILETOCOPY%" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\AMP-db" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
							@echo on
							"%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" "%AMPDBFILETOCOPY%" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\AMP-db" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
							@echo off
							exit /b
						
					:SKIPPINGAMPDB32COPY
						@echo off
						echo.
						echo Skipping copying of AMP related databases...
						echo RawCopy.exe not found under the path "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe"
						echo Please download the program from https://github.com/jschicht
						echo and save the file to the folder "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe"
						echo.
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo RawCopy.exe not found under the path "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Please download the program from https://github.com/jschicht >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo and save the file to the folder "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
						GOTO ENDOFAMPDBCOPY				
			
		:SKIPPINGAMPDBCOPY
		@echo off
		echo.
		echo AMP database(s) not detected on this system
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo AMP database(s) not detected on this system >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		GOTO ENDOFAMPDBCOPY


:ENDOFAMPDBCOPY
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
