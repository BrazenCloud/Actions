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
GOTO MD5HASHTEST

:MD5HASHTEST
	if exist "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" (GOTO RUNMD5HASHING) ELSE (GOTO SKIPPINGMD5Hashing)
		
		:RUNMD5HASHING
			if %OSVer% EQU 1 (GOTO MD5PREVISTAHASHING) ELSE (GOTO MD5POSTVISTAHASHING)

			:MD5PREVISTAHASHING
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%ALLUSERSPROFILE%\Start Menu\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing md5 hash of all files in "%ALLUSERSPROFILE%\Start Menu\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%ALLUSERSPROFILE%\Start Menu\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_md5_Startup_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				GOTO MD5FILEHASHING
				
			:MD5POSTVISTAHASHING
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%ProgramData%\Microsoft\Windows\Start Menu\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing md5 hash of all files in "%ProgramData%\Microsoft\Windows\Start Menu\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%ProgramData%\Microsoft\Windows\Start Menu\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_md5_Startup_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				GOTO MD5FILEHASHING
				
			:MD5FILEHASHING
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%WINDIR%\system32\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing md5 hash of all files in "%WINDIR%\system32\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%WINDIR%\system32\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_md5_System32_AllFiles_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%SystemDrive%\Temp\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing md5 hash of all files in "%SystemDrive%\Temp\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%SystemDrive%\Temp\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_md5_System_TEMP_AllFiles_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%TEMP%\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing md5 hash of all files in "%TEMP%\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -t -r "%TEMP%\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_md5_User_TEMP_AllFiles_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"		
				@echo off
				GOTO ENDOFMD5HASHING			
			
			:SKIPPINGMD5HASHING
			@echo off
			echo.
			echo Skipping md5 hashing...
			echo md5deep64.exe not found under the path "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe"
			echo Please download the program from http://md5deep.sourceforge.net/
			echo and save the file to the folder "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo md5deep64.exe not found under the path "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from http://md5deep.sourceforge.net/ >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
			GOTO ENDOFMD5HASHING

:ENDOFMD5HASHING
GOTO SHA256HASHTEST


:SHA256HASHTEST
	if exist "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" (GOTO RUNSHA256HASHING) ELSE (GOTO SKIPPINGSHA256HASHING)
		
		:RUNSHA256HASHING
			if %OSVer% EQU 1 (GOTO SHA256PREVISTAHASHING) ELSE (GOTO SHA256POSTVISTAHASHING)

				:SHA256PREVISTAHASHING
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%ALLUSERSPROFILE%\Start Menu\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing SHA256 hash of all files in "%ALLUSERSPROFILE%\Start Menu\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%ALLUSERSPROFILE%\Start Menu\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_sha256_Startup_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off		
				GOTO SHA256FILEHASHING
				
				:SHA256POSTVISTAHASHING
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%ProgramData%\Microsoft\Windows\Start Menu\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing SHA256 hash of all files in "%ProgramData%\Microsoft\Windows\Start Menu\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%ProgramData%\Microsoft\Windows\Start Menu\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_sha256_Startup_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off	
				GOTO SHA256FILEHASHING
				
				:SHA256FILEHASHING
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%WINDIR%\system32\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing SHA256 hash of all files in "%WINDIR%\system32\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%WINDIR%\system32\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_sha256_System32_AllFiles_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%SystemDrive%\Temp\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing SHA256 hash of all files in "%SystemDrive%\Temp\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%SystemDrive%\Temp\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_sha256_System_TEMP_AllFiles_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%TEMP%\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo Computing SHA256 hash of all files in "%TEMP%\*"
				echo ...This may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -t -r "%TEMP%\*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Hashes_sha256_User_TEMP_AllFiles_and_Dates.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				GOTO ENDOFHASHING			

			:SKIPPINGSHA256HASHING
			@echo off
			echo.
			echo Skipping sha256 hashing...
			echo sha256deep64.exe not found under the path "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe"
			echo Please download the program from http://md5deep.sourceforge.net/
			echo and save the file to the folder "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo sha256deep64.exe not found under the path "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from http://md5deep.sourceforge.net/ >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
			GOTO ENDOFHASHING		
		
			
:ENDOFHASHING
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"