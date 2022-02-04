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

SET MAINSCRIPTNAME=%~nx0%
SET lrcbuildandname=Live Response Collection (Cedarpelta Build - 20190905)
title %lrcbuildandname%
SET ds=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%
echo %ds% | find "/" > nul
IF %ERRORLEVEL% EQU 0 (GOTO UKDATE) ELSE (GOTO DASHDATECHECK) 
:UKDATE
	echo.
	echo "Possible non United States locale detected!"
	echo "Attempting to format date accordingly"
	SET ds=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
:DASHDATECHECK
	echo %ds% | find "-" > nul
	IF %ERRORLEVEL% EQU 0 (GOTO FOUNDDASHDATE) ELSE (GOTO TIME)
	:FOUNDDASHDATE
		echo.
		echo "Possible non United States locale detected!"
		echo "Attempting to format date accordingly"
		SET ds=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
:TIME
SET ds=%ds:/=%
SET ds=%ds:-=%
SET Now=%Time: =0%
SET Hours=%Now:~0,2%
SET Minutes=%Now:~3,2%
SET Seconds=%Now:~6,2%
SET ts=%Hours%%Minutes%%Seconds%
SET dt=_%ds%_%ts%
SET SCRIPTPATH=%~dps0%
SET TRIMMEDSCRIPTPATH=%SCRIPTPATH:\Scripts=%
SET TOOLSCRIPTPATH=%SCRIPTPATH:\Scripts=\Tools%
SET SCRIPTDRIVELETTER=%~d0%
SET CURRDIR=%CD%
SET FINALCURRDIR=%CURRDIR%\
set TypeOfOS=0
set DoIHaveAdminRights=0
set OSVer=0
set NotEnoughSpaceforAutomatedImaging=0


GOTO PWGENERATOR

:PWGENERATOR
	@Echo Off
	Setlocal EnableDelayedExpansion
	Set _RNDLength=16
	Set _Alphanumeric=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
	Set _Str=%_Alphanumeric%987654321
	:_LenLoop
	IF NOT "%_Str:~18%"=="" SET _Str=%_Str:~9%& SET /A _Len+=9& GOTO :_LenLoop
	SET _tmp=%_Str:~9,1%
	SET /A _Len=_Len+_tmp
	Set _count=0
	SET _RndAlphaNum=
	:_loop
	Set /a _count+=1
	SET _RND=%Random%
	Set /A _RND=_RND%%%_Len%
	SET _RndAlphaNum=!_RndAlphaNum!!_Alphanumeric:~%_RND%,1!
	If !_count! lss %_RNDLength% goto _loop
	SET SECUREPASSWORD=!_RndAlphaNum!
	GOTO INITIALFOLDERSETUPMODULE

:INITIALFOLDERSETUPMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\InitialFolderSetup.bat"
	GOTO CheckOS
	@echo off

:CheckOS
	echo.
	IF exist "%PROGRAMFILES(X86)%" (GOTO 64BIT) ELSE (GOTO 32BIT)
	:64BIT
		set TypeOfOS=64
		echo %TypeOfOS% bit Operating System detected!
		ver | findstr /i "5\." > nul
		IF %ERRORLEVEL% EQU 0 (GOTO PREVISTA) ELSE (GOTO POSTVISTA)
	:32BIT
		set TypeOfOS=32
		echo %TypeOfOS% bit Operating System detected!
		ver | findstr /i "5\." > nul
		IF %ERRORLEVEL% EQU 0 (GOTO PREVISTA) ELSE (GOTO POSTVISTA)
	:PREVISTA
		set OSVer=1
		echo Pre Vista OS detected!
		GOTO check_Permissions	
	:POSTVISTA
		set OSVer=2
		echo Post Vista OS detected!
		GOTO check_Permissions
:check_Permissions
    echo Detecting Administrative permissions...
    net session >nul 2>>&1
    if %errorLevel% EQU 0 (GOTO IHASADMINRIGHTS) ELSE (GOTO NOHASADMINRIGHTS)

:IHASADMINRIGHTS
	echo Administrative permissions confirmed!
	set DoIHaveAdminRights=1
	GOTO MEMORYDUMPMODULE
	
	:MEMORYDUMPMODULE
		@echo off
		CALL "%~dps0%\Windows-Modules\MemoryDumping.bat"
		GOTO DISKSIZESMODULE
		@echo off

	:DISKSIZESMODULE
		@echo off
		CALL "%~dps0%\Windows-Modules\DiskSizes.bat"
		GOTO DISKIMAGINGMODULE
		@echo off
		
	:DISKIMAGINGMODULE
		@echo off
		CALL "%~dps0%\Windows-Modules\DiskImaging.bat"
		if exist "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\%computername%_DrivesNotImagedDueToSpace.txt" (GOTO SETSKIPPEDDRIVEVARIABLE) ELSE (GOTO LASTACTIVITYVIEWMODULE)
		:SETSKIPPEDDRIVEVARIABLE
			Set NotEnoughSpaceforAutomatedImaging=1
			GOTO LASTACTIVITYVIEWMODULE
		@echo off	

	:LASTACTIVITYVIEWMODULE
		@echo off
		CALL "%~dps0%\Windows-Modules\lastactivityview.bat"
		GOTO GATEWAYARPMODULE
		@echo off

	:GATEWAYARPMODULE
		@echo off
		CALL "%~dps0%\Windows-Modules\Gateway-ARP-correlation.bat"
		GOTO OSDETERMINATION
		@echo off
		
	:OSDETERMINATION
	if %TypeOfOS% EQU 64 (GOTO 64BITADMIN) ELSE (GOTO 32BITADMIN)
	:64BITADMIN
	@echo off
	GOTO HASHING64BITMODULE			

		:HASHING64BITMODULE
			@echo off
			CALL "%~dps0%\Windows-Modules\Hashing-64bit.bat"
			GOTO NETSTATANBMODULE
			@echo off

	:32BITADMIN
	@echo off
	GOTO HASHING32BITMODULE
		
		:HASHING32BITMODULE
			@echo off
			CALL "%~dps0%\Windows-Modules\Hashing-32bit.bat"
			GOTO NETSTATANBMODULE
			@echo off			
		
	:NETSTATANBMODULE
		@echo off
		CALL "%~dps0%\Windows-Modules\netstatanb.bat"
		GOTO VolData
		@echo off

:NOHASADMINRIGHTS
	echo Administrative permissions not detected.
	ping 1.1.1.1 -n 1 -w 5000 > nul
	GOTO VolData


:VolData
GOTO AMPDBCOPYING

:AMPDBCOPYING
	@echo off
	CALL "%~dps0%\Windows-Modules\AMP-db-copying.bat"
	GOTO PRCVIEWMODULE
	@echo off

:PRCVIEWMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\prcview.bat"
	GOTO BUILTINCOMMANDSMODULE
	@echo off

:BUILTINCOMMANDSMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\Windows-System-Commands.bat"
	GOTO WINUTILSMODULE
	@echo off

:WINUTILSMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\Winutils.bat"
	GOTO NBTSTATANDCPORTSMODULE
	@echo off

:NBTSTATANDCPORTSMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\nbtstat-cports.bat"
	GOTO WMICMODULE
	@echo off

:WMICMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\WMIC.bat"
	GOTO SYSINTERNALSMODULE
	@echo off

:SYSINTERNALSMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\Sysinternals.bat"
	GOTO WINAUDITMODULE
	@echo off	

:WINAUDITMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\WinAudit.bat"
	GOTO PROCESSINGDETAILSMODULE
	@echo off

:PROCESSINGDETAILSMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\FinalProcessingDetails.bat"
	GOTO SECUREDATAMODULE
	@echo off

:SECUREDATAMODULE
	@echo off
	CALL "%~dps0%\Windows-Modules\SecureData.bat"
	if exist "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt" (GOTO DATAISNOTSECURELYDELETED) ELSE (GOTO SKIPPEDDRIVEDUETOSPACE)
	:DATAISNOTSECURELYDELETED
		@echo off
		echo.
		echo *****ATTENTION!***** *****ATTENTION!***** *****ATTENTION!***** *****ATTENTION!*****
		echo.
		echo The data collected by the Live Response Collection has not been securely deleted. 
		echo Please review the file %computername%%dt%_SkippedSecureDelete.txt, found under the path
		echo "%TRIMMEDSCRIPTPATH%%computername%%dt%\%computername%%dt%_SkippedSecureDelete.txt"
		echo to review why the data was not compressed and/or dele
		echo.
		echo *****ATTENTION!***** *****ATTENTION!***** *****ATTENTION!***** *****ATTENTION!*****
		echo.
		echo.
		GOTO SKIPPEDDRIVEDUETOSPACE
		@echo off
	
:SKIPPEDDRIVEDUETOSPACE
	@echo off
	if %NotEnoughSpaceforAutomatedImaging% EQU 1 (GOTO SKIPPEDDRIVE) ELSE (GOTO PAUSE)
	:SKIPPEDDRIVE
	@echo off
	echo.
	echo *****ATTENTION!***** *****ATTENTION!***** *****ATTENTION!***** *****ATTENTION!*****
	echo.
	echo At least one drive was not imaged due to destination drive being smaller than the source. 
	echo Please review the file DrivesNotImagedDueToSpace.txt, found under the path
	echo "%TRIMMEDSCRIPTPATH%%computername%%dt%\LiveResponseData\BasicInfo\%computername%_DrivesNotImagedDueToSpace.txt"
	echo and manually image any skipped drive(s).
	echo.
	echo *****ATTENTION!***** *****ATTENTION!***** *****ATTENTION!***** *****ATTENTION!*****
	echo.
	echo.
	GOTO PAUSE
	@echo off

:PAUSE
	@echo off
	pause