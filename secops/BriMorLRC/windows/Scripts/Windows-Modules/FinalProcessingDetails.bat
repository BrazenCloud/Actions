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

GOTO PROCESSINGDETAILS

:PROCESSINGDETAILS
echo.
echo.
echo Hashing all collected Live Response data, please wait...
echo.
echo.
@echo off
GOTO PROCESSINGOSTEST

:PROCESSINGOSTEST
	if %TypeOfOS% EQU 64 (GOTO TESTMD564PROCESSINGDETAILS) ELSE (GOTO TESTMD532PROCESSINGDETAILS)

		:TESTMD564PROCESSINGDETAILS
			if exist "%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" (GOTO RUNPROCMD564) ELSE (GOTO SKIPPINGPROCMD564)
				
				:RUNPROCMD564
					echo.  >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"

					echo ==========MD5 HASHES========== >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"

					"%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -r "%TRIMMEDSCRIPTPATH%%computername%%dt%\L*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					"%TOOLSCRIPTPATH%md5deep-4.4\md5deep64.exe" -u -r "%TRIMMEDSCRIPTPATH%%computername%%dt%\ForensicImages\Memory*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					GOTO TESTSHA25664PROCESSINGDETAILS
					
				:SKIPPINGPROCMD564
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
					GOTO TESTSHA25664PROCESSINGDETAILS
					
		:TESTSHA25664PROCESSINGDETAILS
			if exist "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" (GOTO RUNPROCSHA25664) ELSE (GOTO SKIPPINGPROCSHA25664)

				:RUNPROCSHA25664
					echo.  >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					echo ==========SHA256 HASHES========== >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
				
					"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -r "%TRIMMEDSCRIPTPATH%%computername%%dt%\L*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep64.exe" -u -r "%TRIMMEDSCRIPTPATH%%computername%%dt%\ForensicImages\Memory*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					@echo off
					GOTO ENDOFPROCESSINGDETAILS
					
				:SKIPPINGPROCSHA25664
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
					GOTO ENDOFPROCESSINGDETAILS


					
		:TESTMD532PROCESSINGDETAILS
			if exist "%TOOLSCRIPTPATH%md5deep-4.4\md5deep.exe" (GOTO RUNPROCMD532) ELSE (GOTO SKIPPINGPROCMD532)
				
				:RUNPROCMD532
					echo.  >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"

					echo ==========MD5 HASHES========== >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"

					"%TOOLSCRIPTPATH%md5deep-4.4\md5deep.exe" -u -r "%TRIMMEDSCRIPTPATH%%computername%%dt%\L*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					"%TOOLSCRIPTPATH%md5deep-4.4\md5deep.exe" -u -r "%TRIMMEDSCRIPTPATH%%computername%%dt%\ForensicImages\Memory*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					GOTO TESTSHA25632PROCESSINGDETAILS
					
				:SKIPPINGPROCMD532
					@echo off
					echo.
					echo Skipping md5 hashing...
					echo md5deep.exe not found under the path "%TOOLSCRIPTPATH%md5deep-4.4\md5deep.exe"
					echo Please download the program from http://md5deep.sourceforge.net/
					echo and save the file to the folder "%TOOLSCRIPTPATH%md5deep-4.4\md5deep.exe"
					echo.
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo md5deep.exe not found under the path "%TOOLSCRIPTPATH%md5deep-4.4\md5deep.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Please download the program from http://md5deep.sourceforge.net/ >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo and save the file to the folder "%TOOLSCRIPTPATH%md5deep-4.4\md5deep.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
					GOTO TESTSHA25632PROCESSINGDETAILS
					
		:TESTSHA25632PROCESSINGDETAILS
			if exist "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep.exe" (GOTO RUNPROCSHA25632) ELSE (GOTO SKIPPINGPROCSHA25632)

				:RUNPROCSHA25632
					echo.  >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					echo ==========SHA256 HASHES========== >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
				
					"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep.exe" -u -r "%TRIMMEDSCRIPTPATH%%computername%%dt%\L*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					"%TOOLSCRIPTPATH%md5deep-4.4\sha256deep.exe" -u -r "%TRIMMEDSCRIPTPATH%%computername%%dt%\ForensicImages\Memory*" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_File_Hashes.txt"
					@echo off
					GOTO ENDOFPROCESSINGDETAILS
					
				:SKIPPINGPROCSHA25632
					@echo off
					echo.
					echo Skipping sha256 hashing...
					echo sha256deep.exe not found under the path "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep.exe"
					echo Please download the program from http://md5deep.sourceforge.net/
					echo and save the file to the folder "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep.exe"
					echo.
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo sha256deep.exe not found under the path "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Please download the program from http://md5deep.sourceforge.net/ >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo and save the file to the folder "%TOOLSCRIPTPATH%md5deep-4.4\sha256deep.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
					GOTO ENDOFPROCESSINGDETAILS
			
:ENDOFPROCESSINGDETAILS
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"