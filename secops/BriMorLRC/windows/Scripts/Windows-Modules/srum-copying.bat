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
GOTO SRUMTEST

:SRUMTEST
		if exist "%WINDIR%\AppCompat\Programs\Amcache.hve" (GOTO RUNSRUMCOPY) ELSE (GOTO SKIPPINGSRUMCOPY)
		
			:RUNSRUMCOPY
				if %TypeOfOS% EQU 64 (GOTO 64BITSRUMCOPY) ELSE (GOTO 32BITSRUMCOPY)
				
				:64BITSRUMCOPY
					if exist "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" (GOTO RUNSRUM64COPY) ELSE (GOTO SKIPPINGSRUM64COPY)
					
					:RUNSRUM64COPY
						echo Preparing to copy SRUM database
						echo.
						mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\SRUMDB"
						@echo off
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\SRUMDB" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" "%WINDIR%\System32\sru\SRUDB.dat" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\SRUMDB" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						@echo on
						"%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" "%WINDIR%\System32\sru\SRUDB.dat" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\SRUMDB" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
						@echo off
						GOTO ENDOFSRUMCOPY	
						
					:SKIPPINGSRUM64COPY
						@echo off
						echo.
						echo Skipping copying of SRUDB.dat...
						echo RawCopy64.exe not found under the path "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe"
						echo Please download the program from https://github.com/jschicht
						echo and save the file to the folder "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe"
						echo.
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo RawCopy64.exe not found under the path "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Please download the program from https://github.com/jschicht >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo and save the file to the folder "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
						GOTO ENDOFSRUMCOPY						
						
					
				:32BITSRUMCOPY
					if exist "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" (GOTO RUNSRUM32COPY) ELSE (GOTO SKIPPINGSRUM32COPY)
					
					:RUNSRUM32COPY
						echo Preparing to copy SRUM database
						echo.
						mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\SRUMDB"
						@echo off
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\SRUMDB" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" "%WINDIR%\System32\sru\SRUDB.dat" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\SRUMDB" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						@echo on
						"%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" "%WINDIR%\System32\sru\SRUDB.dat" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\SRUMDB" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
						@echo off
						GOTO ENDOFSRUMCOPY	
						
					:SKIPPINGSRUM32COPY
						@echo off
						echo.
						echo Skipping copying of SRUDB.dat...
						echo RawCopy.exe not found under the path "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe"
						echo Please download the program from https://github.com/jschicht
						echo and save the file to the folder "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe"
						echo.
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo RawCopy.exe not found under the path "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Please download the program from https://github.com/jschicht >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo and save the file to the folder "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
						GOTO ENDOFSRUMCOPY				
			
		:SKIPPINGSRUMCOPY
		@echo off
		echo.
		echo SRUM database not detected on this system
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo SRUM database not detected on this system >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		GOTO ENDOFSRUMCOPY


:ENDOFSRUMCOPY
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
