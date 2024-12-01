
# Description -------------------------------------------------------------

# Explore birth data from FHI statistikkbank


# Libraries and data ------------------------------------------------------

library(data.table)
library(ggplot2)

due_date <- fread("data/processed/due_date.csv")
