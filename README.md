# Temp
VS Code Powershell Extension Error Files

While debugging a script that has a breakpoint set and which raises an error from the command Start-ThreadJob, the integrated terminal reports an error from a script not being debugged. The error reads:

ParentContainsErrorRecordException: 
    Line |
      22 |          if ($LastHistoryEntry.Id -eq $Global:__LastHistoryId) {
         |              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         | The property 'Id' cannot be found on this object. Verify that the property exists.
    > 
This code appears to be similar to code found here:
https://github.com/microsoft/terminal/pull/14341

SETUP
************************************************
1) The demo script tries to act on four mp4 files. The sample mp4 files are very small files that display a count from 1 to 4. I have tried to edit the script to remove the need for the mp4 files but then lose the bug behavior.

2) Download the zip file 'temp_dir.zip' from https://github.com/Abax378/Temp/blob/main/temp_dir.zip
Unzip the contents to C:\. The resulting directories and files should be

    C:\temp\video_1.mp4
    C:\temp\video_2.mp4
    C:\temp\temp2\video_3.mp4
    C:\temp\temp2\video_3.mp4

3) Download the demo script 'demo_ext_err.ps1' from https://github.com/Abax378/Temp/blob/main/demo_ext_err.ps1

STEPS TO REPRODUCE
************************************************
1) Open the script 'demo_ext_err.ps1' with VS Code. The Powershell extension terminal should be visible (by default).
2) Kill the Powershell extension terminal. Answer no to the Restart dialog and kill the "Go to output window" dialog.
3) Close the script.
4) Close VS Code.
5) Open VS Code.
6) Open the script 'demo_ext_err.ps1'. A PowerShell Extension v2022.12.1 terminal should automatically open up (but no others terminals are open).
7) Set a breakpoint on line 55. (  Line 55 reads "If ($arrJobs.Count -ne 0) {"  ).
8) Start debug by placing the cursor anywhere in the script and pressing F5.
9) An error about Line 22 should appear in the integrated terminal.

SYSTEM INFORMATION
************************************************
CPUs	Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz (8 x 3204)
GPU Status	2d_canvas: unavailable_software canvas_oop_rasterization: disabled_off 
                                    direct_rendering_display_compositor: disabled_off_ok gpu_compositing: 
                                    disabled_software multiple_raster_threads: enabled_on opengl: 
                                    disabled_off rasterization: disabled_software raw_draw: disabled_off_ok 
                                    skia_renderer: enabled_on video_decode: disabled_software 
                                    video_encode: disabled_software vulkan: disabled_off webgl: 
                                    unavailable_software webgl2: unavailable_software webgpu: 
                                    disabled_off
Load (avg)	
Memory (System)	5.99GB (1.26GB free)
Process Argv	
Screen Reader	no
VM	0%

ENABLED EXTENSIONS
************************************************
Extension	Author (truncated)	Version
vcard	cst	1.0.1
vscode-dotnet-runtime	ms-	1.6.0
powershell	ms-	2022.12.1

$PSVersionTable
************************************************
Name                           Value
----                           -----
PSVersion                      7.3.1
PSEdition                      Core
GitCommitId                    7.3.1
OS                             Microsoft Windows 10.0.19044
Platform                       Win32NT
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}       
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0

WINDOWS VERSION
************************************************
Windows 10
Version 21H2 (OS Build 19044.2364)
