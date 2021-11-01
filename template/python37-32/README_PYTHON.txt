Build information for Python Applets

There are two primary ways to deliver a python script to an endpoint.

1) place a stand-alone copy of python.exe into the applet directory

-or-

2) compile your python script into an executable using py2exe or pyinstaller

OPTION 1: stand alone python
----------------------------

Position independent python can be downloaded from:
https://github.com/manthey/pyexe/releases/tag/v18

From the readme:

To add modules to a position independent python, you can use pip to install modules from pypi to the local directory. 

For instance:

py36-64.exe -m pip install --no-cache-dir --target . --upgrade sympy

Use -m pip to run the pip module. Use --no-cache-dir to avoid writing files to the user's data directory. Use --target . to install to the current directory, allowing you to import the modules easily. Use --upgrade to replace existing files, such as the common bin directory. Note that using --upgrade will overwrite or discard existing files, which may not be what you want (the bin directory will end up with just files for the most recently installed package).

OPTION 2 - compile your script
------------------------------

If you wish to compile your python script into an executable, download pyinstaller from:
https://github.com/pyinstaller/pyinstaller/releases/download/v4.2/PyInstaller-4.2.tar.gz

Decompress pyinstaller to a directory and use it as follows.
 - Change directory to where your script is and run the following command:
 - run PATH_TO_PYINSTALLER\pyinstaller-4.2\pyinstaller --onefile yourscript.py
 - the resulting compiled python script will be in the ./dist directory