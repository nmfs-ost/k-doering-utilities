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

# Download github files (minus source code) locally ----
local_dest_folder <- "download_archives"
gitcellar::download_organization_repos(org, dest_fold = local_dest_folder)

# download source code manually ----
# TODO: could also do this for wikis, if we really wanted to.
tar_files <- list.files(local_dest_folder, recursive = TRUE)
tar_files_full <- list.files(local_dest_folder, recursive = TRUE,   full.names = TRUE)
# use info in tar_files to get the repo names in the same order as the tar_files
repo_names <- strsplit(tar_files, split = "/")
repo_names <- unlist(lapply(repo_names, function (x) x[1]))
repo_names <- strsplit(repo_names, split = paste0("archive-", org, "_"))
repo_names <- unlist(lapply(repo_names, function (x) x[2]))


for (i in seq_along(tar_files_full)) {
  current_tar_path <- tar_files_full[i]
  current_repo_name <- repo_names[i]
  current_zip_name <- file.path(dirname(current_tar_path),
    paste0("archive-", org, "_", current_repo_name, "-source_code.zip"))
  archive_url <- paste0("https://github.com/", org, "/", current_repo_name , ".git")
  folder_to_clone_in <- file.path(dirname(current_tar_path), "source_code")
  gert::git_clone(archive_url, bare = FALSE, path = folder_to_clone_in)
  gert::git_archive_zip(file = current_zip_name, repo = folder_to_clone_in)
  unlink(folder_to_clone_in, recursive = TRUE, force = TRUE)
}

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
