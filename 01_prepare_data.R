

# Description -------------------------------------------------------------

# Prepare birth data downloaded from this link

# http://statistikkbank.fhi.no/mfr/index.jsp?headers=virtual&stubs=mors_bosted_fylke&stubs=fodselstidspunkt_aar&measure=common&virtualslice=asvlen_value&mors_bosted_fylkeslice=01&study=http%3A%2F%2F10.0.3.47%3A80%2Fobj%2FfStudy%2Ff6.svangerskapsvarighet&fodselstidspunkt_aarslice=1967&mors_bosted_fylkesubset=01+-+18&mode=cube&virtualsubset=asvlen_kat_02_value+-+ssvlen_value&v=2&fodselstidspunkt_aarsubset=1967+-+2023&submode=table&measuretype=4&cube=http%3A%2F%2F10.0.3.47%3A80%2Fobj%2FfCube%2Ff6.svangerskapsvarighet_C1&top=yes


# Libraries and data ------------------------------------------------------

library(readxl)
library(data.table)
library(zoo)

due_date <- read_xls("data/1733082117820.xls",
                     skip = 4,
                     na = "-")

due_date <- as.data.table(due_date)


# Fix some columns --------------------------------------------------------

due_date <- due_date[2:.N]
due_date <- due_date[, 2:ncol(due_date)]

unique(due_date[[1]])
setnames(due_date, 1, "year")
due_date[, year := as.integer(year)]

# Convert all numeric columns
cols_num <- 2:ncol(due_date)
due_date[, (cols_num) := lapply(.SD, as.numeric), .SDcols = cols_num]

# Fix column names
names(due_date) <- tolower(names(due_date))

names(due_date)[2:3] <- paste0("reported_", c("antall", "prosent"))
names(due_date)[22:23] <- paste0("week_", c("mean", "sd"))
names(due_date) <- gsub(".*?([0-9]+.*)", "week_\\1", names(due_date))
names(due_date) <- gsub(", ", "_", names(due_date))
names(due_date) <- gsub("‑", "_", names(due_date))
names(due_date) <- gsub("\\+", "_onwards", names(due_date))
names(due_date) <- gsub("antall", "total", names(due_date))
names(due_date) <- gsub("prosent", "pct", names(due_date))

# Remove total
due_date <- due_date[, !grepl("total", names(due_date)), with = FALSE]
names(due_date) <- gsub("_pct", "", names(due_date))


