

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

