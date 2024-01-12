# Archive github repos using googledrive -----
# using windows task scheduler, run the run_archive_github.bat file to run this
# at a scheduled time.
# If there is a way to set this up on gha, that would be preferable, as then it
# doesn't require local settings.

# setup -----
# manual changes
org <- "r4ss" # could change to other github org names.
# google drive folder where the backups will be added. This already exists in 
# gdrive (set permissions on this folder on gdrive, and the uploads will inherit
# them)
backup_folder <- "https://drive.google.com/drive/u/0/folders/1Qbs9ts4cQ9XlJ2mj6ZQAMSR4dAFQSTup"
#install.packages("googledrive")
#devtools::install_github("ropensci-org/gitcellar")
library(gitcellar)
library(googledrive)
library(gert)

# use an auto auth setting so no interaction is needed
# See gargle's "Non-interactive auth" vignette for more details:
# https://gargle.r-lib.org/articles/non-interactive-auth.html
options(gargle_oauth_email = "*@noaa.gov")

# Download github files locally ----
# note to see the source code, you would need to clone the .git 
# folder to another folder. All the files are there, but not visible,
# because this is a bare git repository.
local_dest_folder <- "download_archives"
gitcellar::download_organization_repos(org, dest_fold = local_dest_folder)

# upload to googledrive ----
files_to_upload <- list.files(local_dest_folder, recursive = TRUE)
lapply(files_to_upload, function(archive_file, local_dest_folder) {
  local_file_path <- file.path(local_dest_folder, archive_file)
  g_drive_path <- googledrive::as_id(backup_folder)
  g_drive_name <- basename(archive_file)
  # upload to google drive (expect needing some authentification, will be taken to browser)
  # drive put will either make a new file if one doesnt exist, or update the
  # version if one already exists.
  googledrive::drive_put( media = local_file_path,  path = g_drive_path, 
  name = g_drive_name)
}, local_dest_folder = local_dest_folder)
 
# cleanup ----
unlink(local_dest_folder, recursive = TRUE)
