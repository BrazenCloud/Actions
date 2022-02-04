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
GOTO USRCLASSTEST

:USRCLASSTEST
		echo.
		echo Testing to ensure UsrClass.dat files have been copied
		echo. 
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo ***Testing to ensure UsrClass.dat files have been copied >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		if exist "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry\*USRCLASS.DAT" (GOTO SKIPPINGUSRCLASSCOPY) ELSE (GOTO RUNUSRCLASSCOPY)
		
			:RUNUSRCLASSCOPY
				if %TypeOfOS% EQU 64 (GOTO 64BITUSRCLASSCOPY) ELSE (GOTO 32BITUSRCLASSCOPY)
				
				:64BITUSRCLASSCOPY
					if exist "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" (GOTO RUNUSRCLASS64COPY) ELSE (GOTO SKIPPINGUSRCLASS64COPY)
					
					:RUNUSRCLASS64COPY
						echo Preparing to copy USRCLASS Files
						echo.
						mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry"
						@echo off
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: "%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" "%WINDIR%\System32\sru\SRUDB.dat" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						@echo on
						"%TOOLSCRIPTPATH%RawCopy\RawCopy64.exe" "%WINDIR%\System32\sru\SRUDB.dat" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
						@echo off
						GOTO ENDOFUSRCLASSCOPY	
						
					:SKIPPINGUSRCLASS64COPY
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
						GOTO ENDOFUSRCLASSCOPY						
						
					
				:32BITUSRCLASSCOPY
					if exist "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" (GOTO RUNUSRCLASS32COPY) ELSE (GOTO SKIPPINGUSRCLASS32COPY)
					
					:RUNUSRCLASS32COPY
						echo Preparing to copy USRCLASS database
						echo.
						mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry"
						@echo off
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: mkdir "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						echo Command Run: "%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" "%WINDIR%\System32\sru\SRUDB.dat" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
						@echo on
						"%TOOLSCRIPTPATH%RawCopy\RawCopy.exe" "%WINDIR%\System32\sru\SRUDB.dat" "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\CopiedFiles\registry" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 2>&1
						@echo off
						GOTO ENDOFUSRCLASSCOPY	
						
					:SKIPPINGUSRCLASS32COPY
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
						GOTO ENDOFUSRCLASSCOPY				
			
		:SKIPPINGUSRCLASSCOPY
		@echo off
		echo.
		echo USRCLASS database not detected on this system
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo USRCLASS database not detected on this system >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		GOTO ENDOFUSRCLASSCOPY


:ENDOFUSRCLASSCOPY
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
