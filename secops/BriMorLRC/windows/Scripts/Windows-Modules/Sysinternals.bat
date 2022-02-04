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
GOTO AUTORUNS

:AUTORUNS
	if %TypeOfOS% EQU 64 (GOTO 64BITAUTORUNS) ELSE (GOTO 32BITAUTORUNS)

		:64BITAUTORUNS
		if exist "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" (GOTO RUNAUTORUNS) ELSE (GOTO SKIPPINGAUTORUNS)
			:RUNAUTORUNS
				echo.
				echo Querying to see if Sysinternals Autorun EULA is already accepted on system...
				echo If the value does not exist, you will see an "ERROR" message in the
				echo command prompt window. This is normal.
				echo If the value does exist, you will see a message containing "EulaAccepted"
				echo in the command prompt window. This is normal.
				echo.
				REG QUERY HKCU\SOFTWARE\Sysinternals\AutoRuns /v EulaAccepted
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\AutoRuns /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
				IF %errorlevel%==1 (
					echo.
					echo Registry entry for AutoRuns EULA not found. The AutoRun folder will be deleted upon completion
					@echo off
					echo Registry entry for AutoRuns EULA not found. The AutoRun folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo.
					@echo off
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" -c -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Gathering autorun data may take a few minutes. Please be patient...
					@echo on
					"%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\autorunsc.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo on
					"%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" -c -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\autorunsc.csv" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo off
					REG DELETE "HKCU\Software\Sysinternals\AutoRuns" /f
					@echo off
					echo Command Run: REG DELETE "HKCU\Software\Sysinternals\AutoRuns" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					GOTO PSFILE
				)
				echo Registry entry for AutoRuns EULA found. The AutoRun folder will NOT be deleted upon completion.
				echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
				echo.
				REG ADD "HKCU\Software\Sysinternals\AutoRuns" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
				@echo off
				echo Registry entry for AutoRuns EULA found. The AutoRun folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: REG ADD "HKCU\Software\Sysinternals\AutoRuns" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" -c -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Gathering autorun data may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\autorunsc.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				"%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" -c -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\autorunsc.csv" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				GOTO PSFILE

			:SKIPPINGAUTORUNS
				@echo off
				echo.
				echo Skipping autoruns...
				echo autorunsc64.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe"
				echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
				echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
				echo.
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo autorunsc64.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"		
				GOTO PSFILE

	:32BITAUTORUNS
		if exist "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" (GOTO RUNAUTORUNS) ELSE (GOTO SKIPPINGAUTORUNS)
			:RUNAUTORUNS
				echo.
				echo Querying to see if Sysinternals Autorun EULA is already accepted on system...
				echo If the value does not exist, you will see an "ERROR" message in the
				echo command prompt window. This is normal.
				echo If the value does exist, you will see a message containing "EulaAccepted"
				echo in the command prompt window. This is normal.
				echo.
				REG QUERY HKCU\SOFTWARE\Sysinternals\AutoRuns /v EulaAccepted
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\AutoRuns /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
				IF %errorlevel%==1 (
					echo.
					echo Registry entry for AutoRuns EULA not found. The AutoRun folder will be deleted upon completion
					@echo off
					echo Registry entry for AutoRuns EULA not found. The AutoRun folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo.
					@echo off
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" -c -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					echo Gathering autorun data may take a few minutes. Please be patient...
					@echo on
					"%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\autorunsc.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo on
					"%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" -c -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\autorunsc.csv" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					@echo off
					REG DELETE "HKCU\Software\Sysinternals\AutoRuns" /f
					@echo off
					echo Command Run: REG DELETE "HKCU\Software\Sysinternals\AutoRuns" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
					GOTO PSFILE
				)
				echo Registry entry for AutoRuns EULA found. The AutoRun folder will NOT be deleted upon completion.
				echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
				echo.
				REG ADD "HKCU\Software\Sysinternals\AutoRuns" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
				@echo off
				echo Registry entry for AutoRuns EULA found. The AutoRun folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: REG ADD "HKCU\Software\Sysinternals\AutoRuns" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" -c -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Gathering autorun data may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\autorunsc.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				"%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" -c -s -h -m -a * /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\PersistenceMechanisms\autorunsc.csv" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				GOTO PSFILE

			:SKIPPINGAUTORUNS
				@echo off
				echo.
				echo Skipping autoruns...
				echo autorunsc.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe"
				echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
				echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
				echo.
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo autorunsc.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\autorunsc.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"		
				GOTO PSFILE

:PSFILE

	if exist "%TOOLSCRIPTPATH%SysinternalsSuite\psfile.exe" (GOTO RUNPSFILE) ELSE (GOTO SKIPPINGPSFILE)
	:RUNPSFILE
		echo.
		echo Querying to see if Sysinternals PsFile EULA is already accepted on system...
		echo If the value does not exist, you will see an "ERROR" message in the
		echo command prompt window. This is normal.
		echo If the value does exist, you will see a message containing "EulaAccepted"
		echo in the command prompt window. This is normal.
		echo.
		REG QUERY HKCU\SOFTWARE\Sysinternals\psfile /v EulaAccepted
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\psfile /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		IF %errorlevel%==1 (
			echo.
			echo Registry entry for PsFile EULA not found. The PsFile folder will be deleted upon completion
			@echo off
			echo Registry entry for PsFile EULA not found. The PsFile folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo.
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\psfile.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
			@echo on
			"%TOOLSCRIPTPATH%SysinternalsSuite\psfile.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\psfile.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo off
			REG DELETE "HKCU\Software\Sysinternals\psfile" /f
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: REG DELETE "HKCU\Software\Sysinternals\psfile" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			GOTO PSINFO
		)
		echo Registry entry for PsFile EULA found. The PsFile folder will NOT be deleted upon completion.
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
		echo.
		REG ADD "HKCU\Software\Sysinternals\psfile" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
		@echo off
		echo Registry entry for PsFile EULA found. The PsFile folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG ADD "HKCU\Software\Sysinternals\psfile" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\psfile.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		@echo on
		"%TOOLSCRIPTPATH%SysinternalsSuite\psfile.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\psfile.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo off
		GOTO PSINFO
	:SKIPPINGPSFILE
		@echo off
		echo.
		echo Skipping psfile...
		echo psfile.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\psfile.exe"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
		echo.	
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo psfile.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\psfile.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		GOTO PSINFO
	

:PSINFO
	if exist "%TOOLSCRIPTPATH%SysinternalsSuite\PsInfo.exe" (GOTO RUNPSINFO) ELSE (GOTO SKIPPINGPSINFO)
	:RUNPSINFO
		echo.
		echo Querying to see if Sysinternals PsInfo EULA is already accepted on system...
		echo If the value does not exist, you will see an "ERROR" message in the
		echo command prompt window. This is normal.
		echo If the value does exist, you will see a message containing "EulaAccepted"
		echo in the command prompt window. This is normal.
		echo.
		REG QUERY HKCU\SOFTWARE\Sysinternals\PsInfo /v EulaAccepted
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\PsInfo /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		IF %errorlevel%==1 (
			echo.
			echo Registry entry for PsInfo EULA not found. The PsInfo folder will be deleted upon completion 
			@echo off
			echo Registry entry for PsInfo EULA not found. The PsInfo folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo.
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\PsInfo.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
			@echo on
			"%TOOLSCRIPTPATH%SysinternalsSuite\PsInfo.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\psinfo.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo off
			REG DELETE "HKCU\Software\Sysinternals\PsInfo" /f
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: REG DELETE "HKCU\Software\Sysinternals\PsInfo" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			GOTO PSLIST
		)
		echo Registry entry for PsInfo EULA found. The PsInfo folder will NOT be deleted upon completion.
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
		echo.
		REG ADD "HKCU\Software\Sysinternals\PsInfo" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
		@echo off
		echo Registry entry for PsInfo EULA found. The PsInfo folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG ADD "HKCU\Software\Sysinternals\PsInfo" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\PsInfo.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		@echo on
		"%TOOLSCRIPTPATH%SysinternalsSuite\PsInfo.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\psinfo.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo off
		GOTO PSLIST
	:SKIPPINGPSINFO
		@echo off
		echo.
		echo Skipping PsInfo...
		echo PsInfo.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\PsInfo.exe"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo PsInfo.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\PsInfo.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		GOTO PSLIST

:PSLIST
	if exist "%TOOLSCRIPTPATH%SysinternalsSuite\pslist.exe" (GOTO RUNPSLIST) ELSE (GOTO SKIPPINGPSLIST)
	:RUNPSLIST
		echo.
		echo Querying to see if Sysinternals PsList EULA is already accepted on system...
		echo If the value does not exist, you will see an "ERROR" message in the
		echo command prompt window. This is normal.
		echo If the value does exist, you will see a message containing "EulaAccepted"
		echo in the command prompt window. This is normal.
		echo.
		REG QUERY HKCU\SOFTWARE\Sysinternals\PsList /v EulaAccepted
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\PsList /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		IF %errorlevel%==1 (
			echo.
			echo Registry entry for PsList EULA not found. The PsList folder will be deleted upon completion 
			@echo off
			echo Registry entry for PsList EULA not found. The PsList folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo.
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\pslist.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
			@echo on
			"%TOOLSCRIPTPATH%SysinternalsSuite\pslist.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\PsList.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo off
			REG DELETE "HKCU\Software\Sysinternals\PsList" /f
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: REG DELETE "HKCU\Software\Sysinternals\PsList" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			GOTO PSLOGGEDON
		)
		echo Registry entry for PsList EULA found. The PsList folder will NOT be deleted upon completion.
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
		echo.
		REG ADD "HKCU\Software\Sysinternals\PsList" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
		@echo off
		echo Registry entry for PsList EULA found. The PsList folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG ADD "HKCU\Software\Sysinternals\PsList" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\pslsit.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		@echo on
		"%TOOLSCRIPTPATH%SysinternalsSuite\pslist.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\PsList.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo off
		GOTO PSLOGGEDON
	:SKIPPINGPSLIST
		@echo off
		echo.
		echo Skipping pslist...
		echo pslist.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\pslist.exe"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo pslist.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\pslist.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		GOTO PSLOGGEDON

:PSLOGGEDON
	if exist "%TOOLSCRIPTPATH%SysinternalsSuite\PsLoggedon.exe" (GOTO RUNPSLOGGEDON) ELSE (GOTO SKIPPINGPSLOGGEDON)
	:RUNPSLOGGEDON
		echo.
		echo Querying to see if Sysinternals PsLoggedon EULA is already accepted on system...
		echo If the value does not exist, you will see an "ERROR" message in the
		echo command prompt window. This is normal.
		echo If the value does exist, you will see a message containing "EulaAccepted"
		echo in the command prompt window. This is normal.
		echo.
		REG QUERY HKCU\SOFTWARE\Sysinternals\PsLoggedon /v EulaAccepted
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\PsLoggedon /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		IF %errorlevel%==1 (
			echo.
			echo Registry entry for PsLoggedon EULA not found. The PsLoggedon folder will be deleted upon completion 
			@echo off
			echo Registry entry for PsLoggedon EULA not found. The PsLoggedon folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo.
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\PsLoggedon.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
			@echo on
			"%TOOLSCRIPTPATH%SysinternalsSuite\PsLoggedon.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\PsLoggedon.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo off
			REG DELETE "HKCU\Software\Sysinternals\PsLoggedon" /f
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: REG DELETE "HKCU\Software\Sysinternals\PsLoggedon" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			GOTO PSLOGLIST
		)
		echo Registry entry for PsLoggedon EULA found. The PsLoggedon folder will NOT be deleted upon completion.
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
		echo.
		REG ADD "HKCU\Software\Sysinternals\PsLoggedon" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
		@echo off
		echo Registry entry for PsLoggedon EULA found. The PsLoggedon folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG ADD "HKCU\Software\Sysinternals\PsLoggedon" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\PsLoggedon.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		@echo on
		"%TOOLSCRIPTPATH%SysinternalsSuite\PsLoggedon.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\PsLoggedon.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo off
		GOTO PSLOGLIST
	:SKIPPINGPSLOGGEDON
		@echo off
		echo.
		echo Skipping PsLoggedon...
		echo PsLoggedon.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\PsLoggedon.exe"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo PsLoggedon.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\PsLoggedon.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		GOTO PSLOGLIST


:PSLOGLIST
	if exist "%TOOLSCRIPTPATH%SysinternalsSuite\psloglist.exe" (GOTO RUNPSLOGLIST) ELSE (GOTO SKIPPINGPSLOGLIST)
	:RUNPSLOGLIST
		echo.
		echo Querying to see if Sysinternals PsLoglist EULA is already accepted on system...
		echo If the value does not exist, you will see an "ERROR" message in the
		echo command prompt window. This is normal.
		echo If the value does exist, you will see a message containing "EulaAccepted"
		echo in the command prompt window. This is normal.
		echo.
		REG QUERY HKCU\SOFTWARE\Sysinternals\PsLoglist /v EulaAccepted
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\PsLoglist /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		IF %errorlevel%==1 (
			echo.
			echo Registry entry for PsLoglist EULA not found. The PsLoglist folder will be deleted upon completion 
			@echo off
			echo Registry entry for PsLoglist EULA not found. The PsLoglist folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo.
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\PsLoglist.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
			@echo on
			"%TOOLSCRIPTPATH%SysinternalsSuite\PsLoglist.exe" /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\PsLoglist.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo off
			REG DELETE "HKCU\Software\Sysinternals\PsLoglist" /f
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: REG DELETE "HKCU\Software\Sysinternals\PsLoglist" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			GOTO TCPVCON
		)
		echo Registry entry for PsLoglist EULA found. The PsLoglist folder will NOT be deleted upon completion.
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
		echo.
		REG ADD "HKCU\Software\Sysinternals\PsLoglist" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
		@echo off
		echo Registry entry for PsLoglist EULA found. The PsLoglist folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG ADD "HKCU\Software\Sysinternals\PsLoglist" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\PsLoglist.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		@echo on
		"%TOOLSCRIPTPATH%SysinternalsSuite\PsLoglist.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\PsLoglist.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo off
		GOTO TCPVCON
	:SKIPPINGPSLOGLIST
		@echo off
		echo.
		echo Skipping PsLoglist...
		echo PsLoglist.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\PsLoglist.exe"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo psloglist.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\psloglist.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		GOTO TCPVCON


:TCPVCON
	if exist "%TOOLSCRIPTPATH%SysinternalsSuite\Tcpvcon.exe" (GOTO RUNTCPVCON) ELSE (GOTO SKIPPINGTCPVCON)
	:RUNTCPVCON
		echo.
		echo Querying to see if Sysinternals TCPView EULA is already accepted on system...
		echo If the value does not exist, you will see an "ERROR" message in the
		echo command prompt window. This is normal.
		echo If the value does exist, you will see a message containing "EulaAccepted"
		echo in the command prompt window. This is normal.
		echo.
		REG QUERY HKCU\SOFTWARE\Sysinternals\TCPView /v EulaAccepted
		@echo off
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\TCPView /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		
		IF %errorlevel%==1 (
			echo.
			echo Registry entry for TCPView EULA not found. The TCPView folder will be deleted upon completion 
			@echo off
			echo Registry entry for TCPView EULA not found. The TCPView folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo.
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\Tcpvcon.exe" -a /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
			@echo on
			"%TOOLSCRIPTPATH%SysinternalsSuite\Tcpvcon.exe" -a /accepteula >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\TCPView.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo off
			REG DELETE "HKCU\Software\Sysinternals\TCPView" /f
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: REG DELETE "HKCU\Software\Sysinternals\TCPView" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			GOTO STREAMS
		)
		echo Registry entry for TCPView EULA found. The TCPView folder will NOT be deleted upon completion.
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
		echo.
		REG ADD "HKCU\Software\Sysinternals\TCPView" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
		@echo off
		echo Registry entry for TCPView EULA found. The TCPView folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: REG ADD "HKCU\Software\Sysinternals\TCPView" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\Tcpvcon.exe" -a >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	
		@echo on
		"%TOOLSCRIPTPATH%SysinternalsSuite\Tcpvcon.exe" -a >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\NetworkInfo\TCPView.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		@echo off
		GOTO STREAMS
	:SKIPPINGTCPVCON
		@echo off
		echo.
		echo Skipping Tcpvcon...
		echo Tcpvcon.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\Tcpvcon.exe"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Tcpvcon.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\Tcpvcon.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		GOTO STREAMS

:STREAMS
	if %OSVer% EQU 1 (GOTO PREVISTASTREAMS) ELSE (GOTO POSTVISTASTREAMS)	
	:PREVISTASTREAMS
		if exist "%TOOLSCRIPTPATH%SysinternalsSuite\streams.exe" (GOTO RUNSTREAMS) ELSE (GOTO SKIPPINGSTREAMS)
		:RUNSTREAMS
			echo.
			echo Querying to see if Sysinternals Streams EULA is already accepted on system...
			echo If the value does not exist, you will see an "ERROR" message in the
			echo command prompt window. This is normal.
			echo If the value does exist, you will see a message containing "EulaAccepted"
			echo in the command prompt window. This is normal.
			echo.
			REG QUERY HKCU\SOFTWARE\Sysinternals\Streams /v EulaAccepted
			@echo off
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: REG QUERY HKCU\SOFTWARE\Sysinternals\Streams /v EulaAccepted >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			
			IF %errorlevel%==1 (
				echo.
				echo Registry entry for Streams EULA not found. The Streams folder will be deleted upon completion 
				@echo off
				echo Registry entry for Streams EULA not found. The Streams folder will be deleted upon completion >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\streams.exe" /accepteula -s %HOMEDRIVE%\ | findstr /r /c:".:" /c:":DATA" | findstr /v /c:"Error opening" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Gathering streams data may take a few minutes. Please be patient...
				@echo on
				"%TOOLSCRIPTPATH%SysinternalsSuite\streams.exe" /accepteula -s %HOMEDRIVE%\ | findstr /r /c:".:" /c:":DATA" | findstr /v /c:"Error opening" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Alternate_data_streams.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				REG DELETE "HKCU\Software\Sysinternals\Streams" /f
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: REG DELETE "HKCU\Software\Sysinternals\Streams" /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				GOTO ENDOFSYSINTERNALS
			)
			echo Registry entry for Streams EULA found. The Streams folder will NOT be deleted upon completion.
			echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function.
			echo.
			REG ADD "HKCU\Software\Sysinternals\Streams" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f
			@echo off
			echo Registry entry for Streams EULA found. The Streams folder will NOT be deleted upon completion. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo The script will ensure the EulaAccepted value is "1" to allow the tool to properly function. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: REG ADD "HKCU\Software\Sysinternals\Streams" /v EulaAccepted /t REG_DWORD /d 0x00000001 /f >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Command Run: "%TOOLSCRIPTPATH%SysinternalsSuite\streams.exe" -a >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Gathering streams data may take a few minutes. Please be patient...
			@echo on
			"%TOOLSCRIPTPATH%SysinternalsSuite\streams.exe" -s %HOMEDRIVE%\ | findstr /r /c:".:" /c:":DATA" | findstr /v /c:"Error opening" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\Alternate_data_streams.txt" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			@echo off
			GOTO ENDOFSYSINTERNALS
		:SKIPPINGSTREAMS
			@echo off
			echo.
			echo Skipping streams...
			echo streams.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\streams.exe"
			echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip
			echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo streams.exe not found under the path "%TOOLSCRIPTPATH%SysinternalsSuite\streams.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the file SysinternalsSuite.zip from https://download.sysinternals.com/files/SysinternalsSuite.zip >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and extract the files to the folder "%TOOLSCRIPTPATH%SysinternalsSuite" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			GOTO ENDOFSYSINTERNALS
	:POSTVISTASTREAMS
		@echo off
		echo.
		echo Skipping streams, as streams is enabled by default on this OS version.
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Skipping streams, as streams is enabled by default on this OS version. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		GOTO ENDOFSYSINTERNALS

:ENDOFSYSINTERNALS
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"	