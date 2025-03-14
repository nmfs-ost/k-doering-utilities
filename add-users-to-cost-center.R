# Add GitHub Enterprise Users to A cost center ----

# see api documentation: https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/billing?apiVersion=2022-11-28#add-users-to-a-cost-center
# These operations need Enterprise Owner permissions to work

## Load libraries ----
library(gitcreds)
library(readxl)
library(gh)
# library(httr)

## Set up credentials ----

# use gitcreds::gitcreds_get() to check gh token credentials.
# Use gitcreds::gitcreds_set() to update the credentials if needed

## Get usernames ----

# example with usernames in the column of a spreadsheet
# Get the names of people to add to the cost center (not)
ost_names <- read_excel("ost_names.xlsx")
#vector of names
ppl_to_add <- ost_names$usernames

# example with 2 users
#ppl_to_add <- c("github-username-1", "github-username-2")
# example with 1 user
#ppl_to_add <- "github-username-1"

## Get the cost center id ----

cost_centers <- gh("GET /enterprises/{enterprise}/settings/billing/cost-centers", enterprise = "NOAA-NMFS")
# will need to dig more into parsing this structure when there are multiple cost centers
ost_id <- cost_centers[[1]][[1]]$id

## Add user(s) to a cost center ----

cost_centers <- gh(
  "POST /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}/resource", 
  enterprise = "NOAA-NMFS", cost_center_id = ost_id, users = as.array(ppl_to_add))
