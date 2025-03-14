# Add GitHub Enterprise Users to A cost center ----

# see api documentation: https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/billing?apiVersion=2022-11-28#add-users-to-a-cost-center
# These operations need Enterprise Owner permissions to work

## Load libraries ----
library(gitcreds)
library(readxl)
library(gh)
library(dplyr)
# library(httr)

## Set up credentials ----

# use gitcreds::gitcreds_get() to check gh token credentials.
# Use gitcreds::gitcreds_set() to update the credentials if needed

## Get all GHEC usernames ----
all_GHEC_users <- read_excel("all_users.xlsx")


## Get list of usernames to add to a cost center ----

# example with usernames in the column of a spreadsheet
# Get the names of people to add to the cost center (not)
filename <- "fmc_names.xlsx"
office_usernames <- read_excel(filename)

#check who is found
#intersect(office_usernames, all_GHEC_users)
# check who is missing; unfortuantely is case sensitive
not_included <- setdiff(office_usernames, all_GHEC_users)

#vector of names

ppl_to_add <- intersect(office_usernames, all_GHEC_users) 
ppl_to_add <- ppl_to_add$usernames


# example with 2 users
#ppl_to_add <- c("github-username-1", "github-username-2")
# example with 1 user
#ppl_to_add <- "github-username-1"

## Get the cost center id ----

cost_centers <- gh("GET /enterprises/{enterprise}/settings/billing/cost-centers", enterprise = "NOAA-NMFS")
# will need to dig more into parsing this structure when there are multiple cost centers
id <- cost_centers[[1]][[13]]$id

## verify users part of enterprise ---



## Add user(s) to a cost center ----
# Note: can only do a mx of 50 users at a time
length(ppl_to_add) #check less than 50, otherwise run in chunks

cost_centers <- gh(
  "POST /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}/resource", 
  enterprise = "NOAA-NMFS", cost_center_id = id, users = as.array(ppl_to_add))

# check added
cost_centers <- gh("GET /enterprises/{enterprise}/settings/billing/cost-centers", enterprise = "NOAA-NMFS")

