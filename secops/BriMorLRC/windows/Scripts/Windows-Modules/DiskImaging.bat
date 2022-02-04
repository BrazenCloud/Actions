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

GOTO IMAGERCHECK
	
:IMAGERCHECK
	if exist "%TOOLSCRIPTPATH%FTKImager-commandline\ftkimager.exe" (GOTO ADMINDISKINFO) ELSE (GOTO SKIPPINGIMAGING)

	:ADMINDISKINFO
	if %DoIHaveAdminRights% EQU 1 (GOTO IHASADMINDISKINFO) ELSE (GOTO NOHASADMINDISKINFO)

		:IHASADMINDISKINFO
			@echo off
			echo.
			echo.Administrative privileges confirmed. Beginning disk imaging process!
			GOTO CURRENTDRIVECHECK

			:CURRENTDRIVECHECK
				@setlocal enableextensions enabledelayedexpansion
				@echo off
				SET CURRENTDRIVE=%SYSTEMDRIVE%
				echo.%SCRIPTPATH% | Find /I "%CURRENTDRIVE%">Nul && ( GOTO SKIPPINGIMAGE ) || ( GOTO CREATINGIMAGE )

			:CREATINGIMAGE
				@echo off
				for /F "tokens=*" %%d in ('type "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_name_wmic.txt" ^| findstr "\:"') do call :processline %%d
				echo.
				echo.
				echo Drive imaging process complete^^!
				GOTO ENDOFDRIVEIMAGING

			:SKIPPINGIMAGE
				@echo off
				echo.
				echo This script will not create a disk image when this command is run directly on the system.
				echo Please run this script from an external USB drive and try again^^!
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo This script will not create a disk image when this command is run directly on the system. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Please run this script from an external USB drive and try again^^! >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				ping 1.1.1.1 -n 1 -w 5000 > nul
				GOTO ENDOFDRIVEIMAGING

			:PROCESSLINE
				@echo off
				SET DRIVELETTERTOIMAGE=%*
				set PRIMARYDRIVELETTER=%DRIVELETTERTOIMAGE%
				set PRIMARYDRIVELETTER=%PRIMARYDRIVELETTER::=_%
				echo.
				echo processing %DRIVELETTERTOIMAGE%
				echo.%SCRIPTPATH% | Find /I "%DRIVELETTERTOIMAGE%">Nul && ( GOTO NOTIMAGINGDESTINATION) || ( GOTO MAKINGADISKIMAGE)


			:NOTIMAGINGDESTINATION
				echo.
				echo This script will not create an image of the destination drive.
				echo If you wish to image the desintation drive please use the GUI
				echo version of FTK Imager, located within the Live Response Collection.
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo This script will not create an image of the destination drive. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo If you wish to image the desintation drive please use the GUI >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo version of FTK Imager, located within the Live Response Collection. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				ping 1.1.1.1 -n 1 -w 5000 > nul
				exit /b


			:MAKINGADISKIMAGE
				echo.
				echo Valid destination check is confirmed^^!
				echo Running destination free space calculation now.
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Valid destination check is confirmed^^! >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Running destination free space calculation now. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				ping 1.1.1.1 -n 1 -w 5000 > nul
				setlocal enableDelayedExpansion
				for /f "tokens=3" %%a in ('dir %SCRIPTDRIVELETTER%\') do (
					set DESTBYTESFREE=%%a
				)
				set DESTBYTESFREE=%DESTBYTESFREE:,=%
				endlocal && set DESTBYTESFREE=%DESTBYTESFREE%
				echo.
				echo Destination has %DESTBYTESFREE% bytes free 
				echo Destination has %DESTBYTESFREE% bytes free >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: for /F "tokens=2" %%a in ('type "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" ^| findstr "%DRIVELETTERTOIMAGE%"') do call :havespace %%a >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				for /F "tokens=2" %%a in ('type "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\LogicalDisk_size_caption_wmic.txt" ^| findstr "%DRIVELETTERTOIMAGE%"') do call :havespace %%a
				exit /b
			:HAVESPACE
				SET SOURCEDRIVESIZE=%*
				@echo off
				echo Source is %SOURCEDRIVESIZE% bytes in size
				echo Source is %SOURCEDRIVESIZE% bytes in size >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				ping 1.1.1.1 -n 1 -w 5000 > nul
				@echo off
				set n1=%SOURCEDRIVESIZE%
				set n2=%DESTBYTESFREE%
				call :padNum n1
				call :padNum n2
				if "%n1%" lss "%n2%" (
				echo.
				echo Destination free space calculation confirmed^^! This script will image %DRIVELETTERTOIMAGE%
				echo Destination free space calculation confirmed^^! This script will image %DRIVELETTERTOIMAGE% >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Command Run: "%TOOLSCRIPTPATH%FTKImager-commandline\ftkimager.exe" %DRIVELETTERTOIMAGE% "%TRIMMEDSCRIPTPATH%%computername%%dt%\ForensicImages\DiskImage\%computername%_%PRIMARYDRIVELETTER%drive" --e01 --frag 4096M --compress 4 --verify >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				@echo on
				"%TOOLSCRIPTPATH%FTKImager-commandline\ftkimager.exe" %DRIVELETTERTOIMAGE% "%TRIMMEDSCRIPTPATH%%computername%%dt%\ForensicImages\DiskImage\%computername%_%PRIMARYDRIVELETTER%drive" --e01 --frag 4096M --compress 4 --verify
				@echo off
				exit /b
				) ELSE (
				echo.
				echo I am sorry. The source drive is not smaller than the free bytes available.
				echo The source drive is %SOURCEDRIVESIZE% bytes in size and 
				echo the destination drive has %DESTBYTESFREE% bytes free.
				echo Please use a larger drive and try again^^!
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo I am sorry. The source drive is not smaller than the destination free bytes available. The source drive %PRIMARYDRIVELETTER% is %SOURCEDRIVESIZE% bytes in size and the destination drive %SCRIPTDRIVELETTER% has %DESTBYTESFREE% bytes free. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo Please use a larger drive and try again^^! >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
				echo.
				echo The source drive %DRIVELETTERTOIMAGE% was not imaged  as it is %SOURCEDRIVESIZE% bytes in size and the destination drive %SCRIPTDRIVELETTER% only has has %DESTBYTESFREE% bytes free. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\%computername%_DrivesNotImagedDueToSpace.txt
				echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\%computername%_DrivesNotImagedDueToSpace.txt
				ping 1.1.1.1 -n 1 -w 5000 > nul
				exit /b
				)

		:NOHASADMINDISKINFO
			echo.
			echo I am sorry. You do not have Administrative privlieges to create a disk image.
			echo This script will terminate immediately.
			echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo I am sorry. You do not have Administrative privlieges to create a disk image. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo This script will terminate immediately. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
			echo.
			GOTO ENDOFDRIVEIMAGING
		
		
		:SKIPPINGIMAGING
		@echo off
		echo.
		echo Skipping disk imaging...
		echo ftkimager.exe not found under the path "%TOOLSCRIPTPATH%FTKImager-commandline\ftkimager.exe"
		echo Please download the program from http://www.accessdata.com/support/product-downloads
		echo and save the file to the folder "%TOOLSCRIPTPATH%FTKImager-commandline\ftkimager.exe"
		echo.
		echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo ftkimager.exe not found under the path "%TOOLSCRIPTPATH%FTKImager-commandline\ftkimager.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo Please download the program from http://www.accessdata.com/support/product-downloads >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
		echo and save the file to the folder "%TOOLSCRIPTPATH%FTKImager-commandline\ftkimager.exe" >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"				
		GOTO ENDOFDRIVEIMAGING		

:padNum
	setlocal enableDelayedExpansion
	set "n=000000000000000!%~1!"
	set "n=!n:~-15!"
	endlocal & set "%~1=%n%"
	exit /b


:ENDOFDRIVEIMAGING
	@echo off
	echo.
	echo ***** Module "%~nx0" has completed. *****
	echo ***** Returning to %MAINSCRIPTNAME% *****
	echo.
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo ***** Module "%~nx0" has completed. ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo ***** Returning to %MAINSCRIPTNAME% ***** >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"
	echo. >> "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_Processing_Details.txt"