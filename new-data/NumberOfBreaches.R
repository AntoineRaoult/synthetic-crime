library(haven)
library(here)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(viridis)

survey <- read_spss(file = here("new-data", "CSBS.sav"))

df <- data.frame(survey)

df <- df %>%
    select(year, questtype, country, region_comb, sizea, numbb) %>%
    rename(org_type = questtype,
           number_employees = sizea,
           number_breaches = numbb) %>%
    mutate(year = ifelse(year == 8, 7, year), # change 2022-SCOT to 2022
           year = year + 2015) %>% # year to real year
    mutate(region_comb = ifelse(region_comb <= 4 | region_comb == 7, 1, # change region_comb values to match country values
                         ifelse(region_comb == 5, 3,
                         ifelse(region_comb == 6, 2, NA)))) %>%
    mutate(country = coalesce(region_comb, country)) %>% # merge cols in country
    select(-region_comb)

df <- df %>%
    select(year, org_type, number_breaches) %>%
    filter(!is.na(number_breaches)) %>%
    mutate(number_breaches =
        ifelse(number_breaches == 1, 0,
        ifelse(number_breaches == 2, 3,
        ifelse(number_breaches == 3, 5,
        ifelse(number_breaches == 4, 10,
        ifelse(number_breaches == 5, 15,
        ifelse(number_breaches == 6, 20,
        ifelse(number_breaches == 7, 25,
        ifelse(number_breaches == 8, 50,
        ifelse(number_breaches == 9, 75,
        ifelse(number_breaches == 10, 100,
        ifelse(number_breaches == 11, 200,
        ifelse(number_breaches == 12, 300,
        ifelse(number_breaches == 13, 400,
        ifelse(number_breaches == 14, 500,
        ifelse(number_breaches == 15, 750,
        ifelse(number_breaches == 16, 1000,
        ifelse(number_breaches == 17, 5000,
        ifelse(number_breaches == 18, 10000,
        ifelse(number_breaches == 19, 100000, NA
        )))))))))))))))))))) %>%
    group_by(year, org_type) %>%
    summarise(number_breaches = mean(number_breaches, na.rm = TRUE)) %>%
    mutate(number_breaches = as.integer(number_breaches),
            org_type = ifelse(org_type == 1, "Private", ifelse(org_type == 2, "Charity", "Education"))
    )

print(df)

df %>%
  ggplot(aes(x=year,y=number_breaches, group=org_type, color=org_type)) +
  geom_line() +
  scale_color_viridis(discrete = TRUE) +
  geom_point() +
  ggtitle("Number of breaches by year") +
  ylab("Number of breaches") +
  xlab("Year")