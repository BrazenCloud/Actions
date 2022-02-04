NAME_VERSION: Live Response Collection (Cedarpelta Build - 20190905)
RELEASE DATE: 20190905
AUTHOR: Brian Moran (brian@brimorlabs.com)
TWITTER: BriMor Labs (@BriMorLabs)
Copyright: 2013-2019, Brian Moran

This file is part of the BriMor Labs Live Response Collection

The Live Response Collection is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

Additionally, usages of all tools fall under the express license agreement stated by the tool itself.



THE INFORMING INFORMATION SECTION:
This is meant to be a collection of tools used to gather and triage data from a live Windows environment.

"Windows Live Response Collection.exe" is a Windows executable program that creates a GUI interface that allows a user to choose the data gathering script of their choice. The executable program was created from HTML application file, and can be somewhat customized (with an icon and logo) if so desired.


"Secure" options, which will automatically compress and password protect gathered data. The program will compute a one-time password which will be used to password protect all of the gathered data. It is important that the end user copy the password, as without the password, the data will not be able to be opened and/or viewed if the "Secure" option is chosen.


"Complete_Windows_Live_Response.bat" must be run with Administrative privileges to work to the fullest extent possible. This script creates everything in the "Memory_Dump_Windows_Live_Response.bat" script, as well as creates full disk images of logical drives (except for network drives) on a device. This script must be run from an external device in order to create the physical disk image. The external device also must have more free space available than the size of the drive(s) that it is imaging (it checks prior to each image being created for free space). This is the ultimate "Plug it in, Run It, Pick it Up" option. The script does check for Administrative privileges, however, running the script with non-administrative privileges will not create the disk image or the memory dumps.


"Memory_Dump_Windows_Live_Response.bat" is the traditional Windows Live Response collection.  When the script will automatically collect a memory dump and copy files of interest (such as Prefetch files) to the %computername% folder. It will also leverage hashdeep to compute the md5 and SHA256 hashes of Windows PE files located in the %WINDIR%\system32 folder and the %SystemDrive%/Temp folder (if it exists). It will also compute the md5 and SHA256 hash of every file, recursively, in the %TEMP% folder. It will also run netstat -anb, to provide results of services with open connections and it will also install winpcap, in order to run an nmap scan in an attempt to detect evidence of ARP poisoning. It needs elevated privileges to perform these functions, but it can be run without Administrative privileges as well but it will not return as in-depth results as it would have if it were run with Administrative privileges 


"Triage_Live_Response.bat" is the "lite" version of the Windows Live Response collection. This gets rid of time consuming elements like the Memory Dump and WinAudit. It is still best to run this with Administrative privileges, but it should work much faster and give an examiner quicker results than the other scripts.




AUTHOR NOTE: I would like to extend a very special "Thank you" to Mari DeGrazia (@maridegrazia), Adrian Leong (@Cheeky4n6Monkey), Ken Pryor (@KDPryor), Josh Madeley (@MadeleyJosh), Roberta Payne (@robertapayne_1), Brad Garnett (@brgarnett), Luca Pugliese (@lupug), Alexis Wells, Kevin Pagano (@KevinPagano3), Mark McKinnon (@markmckinnon), Tom Yarrish (@CdtDelta), Cristina Roura, Mitch Impey (@grumpy4n6), Stacey Randolph (@4n6woman), and Todd Mesick (@tmesick1) for their extensive testing and valuable feedback to make this tool what it is today!




-----CHANGES-----
20190905 - Modified SecureData Windows LRC module to work with the latest version of SDelete.exe
20190411 - Cedarpelta public release
20190308 - Added AMP database copying. Removed MorCopy as compatibility is not fully functional (yet)
20170317 - Added alpha version of MorCopy. Added MorCopy-Copying module
20170228 - Added digital signature to Windows Live Response Collection.exe
20161212 - Bambiraptor Build public release date
20161030 - Babmiraptor Build beta test start. Modified logos for Bambiraptor build. Added RamCapture/RamCapture64 text files at request of Belkasoft
20160913 - Added additional warnings in the event that either 7zip compression or secure delete option module does not complete properly to ensure users know if the data is not properly secured.
20160830 - Changed output folder of TCPVcon.txt to NetworkInfo from BasicInfo
20160825 - Added extra alerts to disk imaging to alert user when a disk is skipped due to size requirements
20160816 - Made small change to Sysinternals module to properly store text output of autoruns and csv output of autoruns
20160112 - Allosaurus Build released
20160105 - Added check for dashes in date variable (to account for Denmark and other regions)
20151230 - Changed processing method to ensure $LogFile is copied by forecopy
20151106 - Allosaurus Build out for beta testing
20151104 - Added Gateway ARP correlation with nmap. Changed disk imaging order in Complete and Secure Complete options. Added check for existence of disk wmic data in WMIC module (needed for disk imaging in Complete/Secure Complete versions. Removed file copying from Complete and Secure Complete options. Changed forecopy.log file copying from RawCopy32/64 to copy.
20151020 - Added output to processing details for LRC build and build date (Allosaurus is first)
20150917 - Added template Windows module for users that wish to write their own modules
20150910 - Finished all modules. Added PEStudio 8.51. Removed PEStudio 8.50. Added 7zip 15.06. Removed 7zip 9.20
20150902 - Added ExtractUSNJrnl-32bit and ExtractUSNJrnl-64bit modules
20150901 - Added lastactivityview, nbtstat-cports, Network-VolData, prcview, and Windows-System-Commands modules
20150803 - Began addition of module features, to allow greater flexibility and user modification of script and output
20150731 - Removed 32 bit debugging pause
20150730 - Changed internal structure of folders to make it easier for users to find data in Windows folder
20150729 - Ensure proper file path for SDelete was present in "secure" options. Created standalone folder for sdelete.
20150728 - Added skipping streams with any OS Vista or later. Updated Windows Compromised System Checklist document.
20150708 - Added SRUM database extraction.
20150515 - Added hashing of files in startup folder, depending on OS (pre-Vista or Vista/later). Added PEStudio 8.50. Removed PEStudio 8.48
20150425 - Added collection of "hosts" file. Added PEStudio 8.48. Removed PEStudio 8.47.
20150326 - Added Sysinternals processing in case SysinternalsSuite folder is not present. Added csv to autoruns output.
20150323 - Added PEStudio 8.47. Removed PEStudio 8.46. Updated autoruns and autorunsc to 13.2. 
20150130 - Updated autoruns and autorunsc to 13.0. Changed command syntax to work with new version.
20150121 - Added logging output. Added check to ensure nbtstat would run properly on x64 systems. Refined GUI wrapper.
20150113 - Added standalone executable for a GUI interface. Beginning work on "secure" gathering option. Added 7zip 9.20
20150112 - Working on basic hta GUI
20150109 - Added PEStudio 8.46
20141208 - Added RecentFileCache.bcf and Amcache.hve file extraction (if present). Added IE, Chrome, and FireFox flag for browser history option to forecopy_handy.
20141205 - Changed sysinternals processing to attempt to find sysinternals EULA in registry first, if so, changes EulaAccepted flag to "1" to ensure running. If no sysinternals registry key is found, runs program with /accepteula flag and deletes folder upon completion.
20141203 - Added WMIC logic checking, C++ Redistributable Package checking (and installation). 
20141201 - Added USNJRNL, Logfile, MFT, Event Logs, and Registry hive copying (using forecopy_handy). Updated to PEStudio 8.44.
20141010 - Updated autoruns and autorunsc to 12.3.0.0. Updated to PEStudio 8.38. Added RawCopy and FGET. Changed sysinternals processing to include /accepteula flag rather than adding registry entries
20141002 - Added automated disk imaging capabilities. Renamed scripts to "Complete_Windows_Live_Response.bat", "Memory_Dump_Windows_Live_Response.bat", and "Triage_Live_Response.bat"
20140930 - Added "-r" flag to md5deep and sha256 deep to ensure all Windows PE files in subdirectories are processed. Added FTK Imager Command line (3.1.1)
20140924 - Added "dd.exe" (dd port for Windows). Working on adding scripting capability to automate imaging of all physical media drives on device.
20140829 - Removed FTK Imager 3.2 and 3.1.4.6. Keeping just FTK Imager Lite.
20140828 - Upgraded to cports 2.1 (32 and 64 bit). Added 32 and 64 bit cports loop in scripts. Upgraded LastActivityView to 1.06. Upgraded md5deep to version 4.4. Upgraded nmap to 6.47. Upgraded PEStudio to 8.35. Upgraded WinAudit to 3.0.8, but retained WinAudit 2.2.9 in "winaudit-old". Added Comprehensive Tool list spreadsheet.
20140815 - Added PEStudio 8.32. Added FTKImager Lite 3.1.1, added FTKImager 3.2. Renamed FTKImager to FTKImager_3.1.4.6.
20140701 - Added Triage_Windows_Live_Response, will run faster than in-depth (no memory dump, no winaudit). Added PEStudio 8.30
20140516 - Added "quotes" to %HOMEPATH%\ in dir command.
20140514 - Changed %~dp0 to %~dps0 to account for possible spaces in pathnames. Added full directory search. Added Alternate Data Stream search. Added Windows code page determination. Added PEStudio 8.26. Added 32bit whoami to account for XP systems not having whoami.exe. Changed Checklist to reflect changes to batch script.
20140416 - Added PEStudio 8.23. Added Pinpoint 0.2. Added md5 and SHA256 hashing of PE files in 
%WINDIR%\system32 folder and the %SystemDrive%/Temp folder (if it exists). It will also compute the md5 and SHA256 hash of every file, recursively, in the %TEMP% folder (For currently logged on user).
20140402 - Added PEStudio 8.17
20140319 - Changed autorunsc command to present more applicable data.
20140313 - Added PEStudio 8.12. Added more hashing tools to unxutils folder. Created folders for output, added automated hashing of data
20140221 - Added PeStudio 8.10
20140211 - Added LastActivityView v1.04
20140207 - Added PeStudio 8.06
20140131 - Added PeStudio 8.05
20140129 - Added PEStudio 8.04
20140124 - Added Pinpoint from kahusecurity.com
20140123 - Added PEStudio 8.02
20140122 - Added PrcView, whoami, ver, NetBIOS sessions, and NetBIOS files. Updated to PEStudio 8.01. Added DumpIt-Free for additional memory capture option
20140117 - Added text for when nmap/winpcap installs/runs. Added timestamps to <computername> folder and memory dump. Adde timestamp formatting to include leading zero when applicable.
20140116 - Added PEStudio 8.00. Added msvcp90.dll, msvcr90.dll, msvcp100.dll, and x86_Microsoft.VC90.CRT.manifest to nmap folder to try to deal with nmap issue. Changed command syntax to account for spaces in full file path names.
20140115 - Added 32bit version of msvcr100.dll to nmap folder. This should take care of C++ issues. Added PEStudio 7.99
20140108 - Upgraded to PeStudio 7.97
20140107 - Added netstat -anb option, if user has elevated privileges.
20131230 - Changed to command line version of nmap. Added more wmic quries. Added systeminfo query.
20131223 - Added option to run as Administrator, which images RAM using Belkasoft Ram Capture and copies Prefetch files. Updated to PeStudio 7.95
20131218 - Updated Sysinternals Tools, updated PeStudio, updated WinAudit output file path, added nmap and basic ARP poisoning detection
20131217 - Updated batch script to run from any folder, not just external drive
20131216 - Updated FTK Imager
