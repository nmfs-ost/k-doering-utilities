# backup-gdrive

Back up github repositories to google drive using the packages gitcellar and google drive.

Note that due to the need to authenticate, this needs to be run on a local machine. The first time,
the r script should be run manually and authenticating to google drive interactively will be
necessary. 

Then, this workflow can be set up using [Windows task scheduler](https://docs.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page),
which calls the .bat file. Note that the cd command in the .bat file is currently hard coded and so will need to be replaced; 
alternatively, the cd command can be removed and the start in argument can be specified in Windows task scheduler:

![Windows task scheduler setup window](https://user-images.githubusercontent.com/48930335/179774960-18acf88c-8fbc-460e-a93a-48f1faeaff8e.png)
