# backup-gdrive

Back up github repositories to google drive using the packages gitcellar and google drive.

Note that due to the need to authenticate, this needs to be run on a local machine. The first time,
the r script should be run manually and authenticating to google drive interactively will be
necessary. 

Then, this workflow can be set up using [Windows task scheduler](https://docs.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page),
which calls the .bat file. Note that the start in argument must specified in Windows task scheduler so that the task starts in the directory where the github repo is cloned:

![Windows task scheduler setup window](https://user-images.githubusercontent.com/48930335/179774960-18acf88c-8fbc-460e-a93a-48f1faeaff8e.png)

# Disclaimer

The United States Department of Commerce (DOC) GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. DOC has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information. Any claims against the Department of Commerce stemming from the use of its GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.”
