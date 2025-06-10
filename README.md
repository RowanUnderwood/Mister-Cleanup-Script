# Mister-Cleanup-Script
One thing that has always bugged me is how your menu gets cluttered with cores you aren't using. (unless you make a custom whitelist for your update) Here is a script that aims to fix that. It scans your files and when noticing a games directory with one file or less in it offers to delete that directory and core. Disclaimer: I am not a programmer and this deletes files :D I did test it out on my own system and nothing bad happened though. You have to watch out for folders that are supposed to have only one file (like my MSX folder has just a VHD file in it. Example output below:

----------------------------------------------------
----------------------------------------------------
Found potential unused directory: /media/fat/games/ZXNext (1 files)
Corresponding core(s) for 'ZXNext': ZXNext
Delete 'ZXNext' and its associated core(s)? (y/s/c) [y=Yes, s=Skip, c=Cancel]: s
Skipping ZXNext.
----------------------------------------------------
----------------------------------------------------
Found potential unused directory: /media/fat/games/eg2000 (0 files)
Corresponding core(s) for 'eg2000': eg2000
Delete 'eg2000' and its associated core(s)? (y/s/c) [y=Yes, s=Skip, c=Cancel]: y
Deleting directory: /media/fat/games/eg2000
Successfully deleted directory: /media/fat/games/eg2000
Attempting to delete core file: /media/fat/_Computer/eg2000_20220930.rbf
Successfully deleted core file: /media/fat/_Computer/eg2000_20220930.rbf
Warning: No core file(s) matching 'eg2000*.rbf' found or deleted in /media/fat/_Computer /media/fat/_Console for 'eg2000'.
Deletion process for eg2000 finished.
----------------------------------------------------
Cleanup process finished.
