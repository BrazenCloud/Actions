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
GOTO MEMORYDUMP

:MEMORYDUMP

if %TypeOfOS% EQU 64 (GOTO 64BITMEMORYDUMP) ELSE (GOTO 32BITMEMORYDUMP)

	:64BITMEMORYDUMP
		@echo off
		if exist "%TOOLSCRIPTPATH%RamCapturer64\RamCapture64.exe" (GOTO RUN64BITMEMORYDUMP) ELSE (GOTO SKIPPING64BITMEMORYDUMP)
			:RUN64BITMEMORYDUMP
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%RamCapturer64\RamCapture64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo on
				"%TOOLSCRIPTPATH%RamCapturer64\RamCapture64.exe" "%TRIMMEDSCRIPTPATH%%computername%%dt%\ForensicImages\Memory\%computername%%dt%_mem.dmp" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				title %lrcbuildandname%
				GOTO ENDOFMEMORYDUMP
			
			:SKIPPING64BITMEMORYDUMP
			@echo off
			echo.
			echo Skipping Memory Dump...
			echo RamCapture64.exe not found under the path "%TOOLSCRIPTPATH%RamCapturer64\RamCapture64.exe"
			echo Please download the program from http://forensic.belkasoft.com/en/ram-capturer
			echo and save the file to the folder "%TOOLSCRIPTPATH%RamCapturer64\RamCapture64.exe"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo RamCapture64.exe not found under the path "%TOOLSCRIPTPATH%RamCapturer64\RamCapture64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from http://forensic.belkasoft.com/en/ram-capturer >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%RamCapturer64\RamCapture64.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"		
			GOTO ENDOFMEMORYDUMP


	:32BITMEMORYDUMP
		@echo off
		if exist "%TOOLSCRIPTPATH%RamCapturer\RamCapture.exe" (GOTO RUN32BITMEMORYDUMP) ELSE (GOTO SKIPPING32BITMEMORYDUMP)
			:RUN32BITMEMORYDUMP
				@echo off
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%RamCapturer\RamCapture.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo on
				"%TOOLSCRIPTPATH%RamCapturer\RamCapture.exe" "%TRIMMEDSCRIPTPATH%%computername%%dt%\ForensicImages\Memory\%computername%%dt%_mem.dmp" 2>> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo off
				title %lrcbuildandname%
				GOTO ENDOFMEMORYDUMP
			
			:SKIPPING32BITMEMORYDUMP
			@echo off
			echo.
			echo Skipping Memory Dump...
			echo RamCapture.exe not found under the path "%TOOLSCRIPTPATH%RamCapturer\RamCapture.exe"
			echo Please download the program from http://forensic.belkasoft.com/en/ram-capturer
			echo and save the file to the folder "%TOOLSCRIPTPATH%RamCapturer\RamCapture.exe"
			echo.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo RamCapture.exe not found under the path "%TOOLSCRIPTPATH%RamCapturer\RamCapture.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo Please download the program from http://forensic.belkasoft.com/en/ram-capturer >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo and save the file to the folder "%TOOLSCRIPTPATH%RamCapturer\RamCapture.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"			
			GOTO ENDOFMEMORYDUMP	


:ENDOFMEMORYDUMP
@echo off
echo.
echo ***** Module "%~nx0" has completed. *****
echo ***** Returning to %MAINSCRIPTNAME% *****
echo.
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"		