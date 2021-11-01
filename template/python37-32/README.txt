
This is a template applet.  Modify it to suit your needs.

The folder structure of the applet is:

Folder:                  ./applet-name				
Manifest:                ./applet-name/manifest.txt    <-- supplied by author
                         ./applet-name/runway.app      <-- *reserved temp file*
Parameters:              ./applet-name/parameters.json <-- supplied by author
Settings:                ./applet-name/settings.json   <-- created at runtime
Additional files:        ./applet-name/*
Result files:            ./applet-name/results/*       <-- created by script or exe


Example:

Folder:                  ./applet-name				
Manifest:                ./applet-name/manifest.txt
Windows support files:   ./applet-name/windows/run.bat
                         ./applet-name/windows/sometool.exe

The manifest is as follows:

COPY . .                 <-- copies files from the applet dir to the compiled applet
RUN_WIN windows\run.bat  <-- run the following command when running the applet

You can build your applet and publish it in one step.

First, ensure you are logged in:

> runway who

If you are not logged in, then login:

> runway login

Then, to build and publish:

> runway build -i ./applet-name/manifest.txt -p namespace:name 

To make the applet public:

> runway build -i ./applet-name/manifest.txt -p namespace:name --PUBLIC

