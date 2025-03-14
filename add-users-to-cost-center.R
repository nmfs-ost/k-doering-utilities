

library(gh)

# library(httr)



cost_centers <- gh("GET /enterprises/{enterprise}/settings/billing/cost-centers", enterprise = "NOAA-NMFS")


# will need to dig more into parsing this structure when there are multiple cost centers
ost_id <- cost_centers[[1]][[1]]$id

# add user(s) to a cost center

cost_centers <- gh(
  "POST /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}/resource", 
  enterprise = "NOAA-NMFS", cost_center_id = ost_id, users = as.array("k-doering-NOAA"))

# try with 2 users
ppl_to_add <- c("e-perl-NOAA", "ChristineStawitz-NOAA")

cost_centers <- gh(
  "POST /enterprises/{enterprise}/settings/billing/cost-centers/{cost_center_id}/resource", 
  enterprise = "NOAA-NMFS", cost_center_id = ost_id, users = as.array(ppl_to_add))
