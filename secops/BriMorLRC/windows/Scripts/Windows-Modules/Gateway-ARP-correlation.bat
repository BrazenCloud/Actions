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

GOTO GATEWAYARP

:GATEWAYARP
		if exist "%TOOLSCRIPTPATH%nmap-6.47\nmap.exe" (GOTO RUNGATEWAYARP) ELSE (GOTO SKIPPINGGATEWAYARP)
		
			:RUNGATEWAYARP
			@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"		
				echo.
				echo Installing WinPcap, C++ Redistributable Package (if needed), and running ARP Gateway Correlation. 
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Installing WinPcap, C++ Redistributable Package (if needed), and running ARP Gateway Correlation. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo This may take awhile, please be patient....
				echo.
				if not exist "%WINDIR%\system32\msvcr100.dll" (
						if %TypeOfOS% EQU 64 (GOTO INSTALL64CPLUSPLUS) ELSE (GOTO INSTALL32CPLUSPLUS)
				) ELSE (GOTO NMAP)
				:INSTALL64CPLUSPLUS
					echo.
					echo Installing C++ Redistributable Package
					echo Installing C++ Redistributable Package >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo.
					@echo off
					echo. >>  "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 
					echo Command Run: "%TOOLSCRIPTPATH%nmap-6.47\vcredist_x64.exe" setup /q >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo on
					"%TOOLSCRIPTPATH%nmap-6.47\vcredist_x64.exe" setup /q 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo off
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 
					echo Command Run: "%TOOLSCRIPTPATH%nmap-6.47\vcredist_x86.exe" setup /q >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"			
					@echo on
					"%TOOLSCRIPTPATH%nmap-6.47\vcredist_x86.exe" setup /q 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					GOTO NMAP
				:INSTALL32CPLUSPLUS
					echo.
					echo Installing C++ Redistributable Package
					echo Installing C++ Redistributable Package >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo.
					@echo off
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 
					echo Command Run: "%TOOLSCRIPTPATH%nmap-6.47\vcredist_x86.exe" setup /q >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"			
					@echo on
					"%TOOLSCRIPTPATH%nmap-6.47\vcredist_x86.exe" setup /q 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					GOTO NMAP
				:NMAP
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 
				echo Command Run: "%TOOLSCRIPTPATH%nmap-6.47\winpcap-nmap-4.13.exe" /S >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				"%TOOLSCRIPTPATH%nmap-6.47\winpcap-nmap-4.13.exe" /S 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 
				echo Command Run: for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "Default gateway" ^|findstr [0-9]') do arp -a %%i >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo on
				for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "Default gateway" ^|findstr [0-9]') do arp -a %%i >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\Gateway_ARP_Lookup.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt" 
				echo Command Run: for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "Default gateway" ^|findstr [0-9]') do "%TOOLSCRIPTPATH%nmap-6.47\nmap.exe" -A %%i >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
				@echo on
				for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "Default gateway" ^|findstr [0-9]') do "%TOOLSCRIPTPATH%nmap-6.47\nmap.exe" -A %%i >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\Gateway_ARP_Lookup.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
				@echo off
				GOTO ENDOFGATEWAYARP			
			
			:SKIPPINGGATEWAYARP
				@echo off
				echo.
				echo Skipping Gateway ARP correlation...
				echo nmap.exe not found under the path "%TOOLSCRIPTPATH%nmap-6.47\nmap.exe"
				echo Please download the program from http://nmap.org/
				echo and save the file to the folder "%TOOLSCRIPTPATH%nmap-6.47"
				echo.
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo nmap.exe not found under the path "%TOOLSCRIPTPATH%nmap-6.47\nmap.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Please download the program from http://nmap.org/ >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo and save the file to the folder "%TOOLSCRIPTPATH%nmap-6.47" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
				GOTO ENDOFGATEWAYARP


:ENDOFGATEWAYARP
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"