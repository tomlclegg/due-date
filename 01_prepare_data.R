

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
names(due_date) <- gsub("\\+", "_plus", names(due_date))
names(due_date) <- gsub("antall", "total", names(due_date))
names(due_date) <- gsub("prosent", "pct", names(due_date))

# Remove total
due_date <- due_date[, !grepl("total", names(due_date)), with = FALSE]
names(due_date) <- gsub("_pct", "", names(due_date))


# Split datasets ----------------------------------------------------------

# Coverage (total births with birth week reported)
coverage <- due_date[, 1:2]
due_date <- due_date[, -2, with = FALSE]

birth_mean <- due_date[, c(1, 11:12)]
due_date <- due_date[, -c(11:12), with = FALSE]


# Prepare due_date --------------------------------------------------------



due_date <- melt(due_date,
                 id.vars = "year",
                 variable.name = "week",
                 value.name = "pct")

due_date[, week := gsub("week_", "", week)]

unique(due_date$week)

# Remove plus value
due_date[, week := gsub("_plus", "", week)]
due_date[week == 43, comment := "week 43 plus"]

# Reduce early weeks to one value
due_date[grepl("_", week), comment := paste("week", week)]
due_date[, week := sub(".*_", "", week)]

due_date[, week := as.integer(week)]


# Save datasets -----------------------------------------------------------

fwrite(due_date,   "data/processed/due_date.csv")
fwrite(coverage,   "data/processed/coverage.csv")
fwrite(birth_mean, "data/processed/birth_mean.csv")
