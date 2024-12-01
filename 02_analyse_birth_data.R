
# Description -------------------------------------------------------------

# Explore birth data from FHI statistikkbank


# Libraries and data ------------------------------------------------------

library(data.table)
library(ggplot2)

due_date <- fread("data/processed/due_date.csv")
week_mean <- fread("data/processed/week_mean.csv")


# Checks ------------------------------------------------------------------

# all percent add up to 100
due_date[,
         .(tot_pct = sum(pct)),
         by = .(year)]


# Cumulative --------------------------------------------------------------

due_date[, cum_pct := cumsum(pct), by = year]


# Plot --------------------------------------------------------------------

ggplot(due_date[year == 2023 & week >= 37],
       aes(x = week,
           y = pct)) +
  geom_col() +
  scale_x_continuous(name = "Week",
                     breaks = 37:43,
                     labels = c(37:42, "43+")) +
  scale_y_continuous(name = "Percent births",
                     breaks = seq(0, 100, by = 5))


ggplot(due_date[year == 2023 & week >= 37],
       aes(x = week,
           y = cum_pct,
           colour = factor(year))) +
  geom_point() +
  geom_line() +
  scale_x_continuous(breaks =1:50)

ggplot(week_mean,
       aes(x = year,
           y = week_mean,
           ymin = week_mean-week_sd,
           ymax = week_mean+week_sd)) +
  geom_line() +
  geom_errorbar()
