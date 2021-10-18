# Runway Actions

Actions for the Runway Automation Platform

This is a repository of actions that are public and can be used with the Runway platform.

## Action Structure

Runway actions are the executable components that are orchestrated by the Runway Platform.  

Each action is organized under a single folder.  Subdirectories are possible, but completely arbitrary.

The folder structure of the action is:

```
Folder:                  ./action-name				
Manifest:                ./action-name/manifest.txt    <-- supplied by author
                         ./action-name/runway.app      <-- *reserved temp file*
Parameters:              ./action-name/parameters.json <-- supplied by author
Settings:                ./action-name/settings.json   <-- created at runtime
Additional files:        ./action-name/*
Result files:            ./action-name/results/*       <-- created by script or exe
```

Example:

```
Folder:                  ./myaction				
Manifest:                ./myaction/manifest.txt
Windows support files:   ./myaction/windows/run.bat
                         ./myaction/windows/sometool.exe
```

The manifest is as follows:

```
COPY . .                 <-- copies files from the action dir to the compiled action
RUN_WIN windows\run.bat  <-- run the following command when running the action on Windows
```
You can use `RUN_LIN` to specify what to execute when running on Linux.

## Building and Publishing an Action

You can build your action and publish it in one step.  This requires the `runway.exe` command line tool.  You can obtain the `runway` command line tool from your account on [portal.runway.host](https://portal.runway.host). There are versions of `runway` for Windows and Linux, both 32 and 64 bit.

First, ensure you are logged in:

> runway who

If you are not logged in, then login:

> runway login

Then, to build and publish:

> runway build -i ./action-name/manifest.txt -p namespace:name 

To make the action public:

> runway build -i ./action-name/manifest.txt -p namespace:name --PUBLIC

TO REQUEST AN ACCOUNT ON RUNWAY CONTACT `info@runway.host`.