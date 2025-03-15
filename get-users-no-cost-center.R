# From GitHub, get users on enterprise without a cost center

## Load libraries ----
library(gitcreds)
library(readxl)
library(gh)
library(dplyr)

## Get all GHEC usernames ----
all_GHEC_users <- read_excel("all_users.xlsx")

## Get the cost center id ----

cost_centers <- gh("GET /enterprises/{enterprise}/settings/billing/cost-centers", enterprise = "NOAA-NMFS")


# get user names for one office
get_office_users <- function (office_costcenter) {
  office_costcenter <- office_costcenter$resources
  usernames <- unlist(lapply(office_costcenter, function (x) x[x$type == "User"][["name"]]))
  usernames
}

# example for 1 office
#get_office_users(cost_centers$costCenters[[1]])

# get user names for all offices
all_cost_center_names <- data.frame(usernames = unlist(lapply(cost_centers$costCenters, get_office_users)))

# compare to the all user list from enterprise, which is the all_GHEC_users
#different than GUI?
not_included <- setdiff(all_GHEC_users, all_cost_center_names)
