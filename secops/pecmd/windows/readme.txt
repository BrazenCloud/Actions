PECmd version 1.4.0.0

 Author: Eric Zimmerman (saericzimmerman@gmail.com)
 https://github.com/EricZimmerman/PECmd
 
         d               Directory to recursively process. Either this or -f is required
         f               File to process. Either this or -d is required
         k               Comma separated list of keywords to highlight in output. By default, 'temp' and 'tmp' are highlighted. Any additional keywords will be added to these.
         o               When specified, save prefetch file bytes to the given path. Useful to look at decompressed Win10 files
         q               Do not dump full details about each file processed. Speeds up processing when using --json or --csv. Default is FALSE
 
         json            Directory to save json representation to.
         jsonf           File name to save JSON formatted results to. When present, overrides default name
         csv             Directory to save CSV results to. Be sure to include the full path in double quotes
         csvf            File name to save CSV formatted results to. When present, overrides default name
         html            Directory to save xhtml formatted results to. Be sure to include the full path in double quotes
         dt              The custom date/time format to use when displaying timestamps. See https://goo.gl/CNVq0k for options. Default is: yyyy-MM-dd HH:mm:ss
         mp              When true, display higher precision for timestamps. Default is FALSE
 
         vss             Process all Volume Shadow Copies that exist on drive specified by -f or -d . Default is FALSE
         dedupe          Deduplicate -f or -d & VSCs based on SHA-1. First file found wins. Default is TRUE

         debug           Show debug information during processing
         trace           Show trace information during processing
 
 Examples: PECmd.exe -f "C:\Temp\CALC.EXE-3FBEF7FD.pf"
           PECmd.exe -f "C:\Temp\CALC.EXE-3FBEF7FD.pf" --json "D:\jsonOutput" --jsonpretty
           PECmd.exe -d "C:\Temp" -k "system32, fonts"
           PECmd.exe -d "C:\Temp" --csv "c:\temp" --csvf foo.csv --json c:\temp\json
           PECmd.exe -d "C:\Windows\Prefetch"

           Short options (single letter) are prefixed with a single dash. Long commands are prefixed with two dashes