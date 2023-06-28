library(haven)
library(here)
library(tidyr)
library(MASS)
library(rsq)
library(faux)
library(DescTools)
library(ggplot2)
library(ggpubr)
library(BinNor)
library(BinOrdNonNor)
library(dplyr)

survey <- read_spss(file = here("new-data", "CSBS.sav"))

df <- data.frame(survey)

df <- df %>%
    select(year, questtype, country, region_comb, sizea, numbb) %>%
    rename(org_type = questtype,
           number_employees = sizea) %>%
    mutate(year = ifelse(year == 8, 7, year), # change 2022-SCOT to 2022
           year = year + 2015) %>% # year to real year
    mutate(region_comb = ifelse(region_comb <= 4 | region_comb == 7, 1, # change region_comb values to match country values
                         ifelse(region_comb == 5, 3,
                         ifelse(region_comb == 6, 2, NA)))) %>%
    mutate(country = coalesce(region_comb, country)) %>% # merge cols in country
    select(-region_comb) %>%
    filter(org_type == 1 & number_employees != -97) %>%
    select(-org_type) %>%
    filter(!is.na(numbb)) %>%
    rename(number_breaches = numbb)

syn_data <- data.frame()

syn_data <- mvrnorm(n=nrow(df), 
                    mu=c(mean(df$year), mean(df$country), mean(df$number_employees), mean(df$number_breaches)),
                    Sigma=cov(df), 
                    empirical=TRUE)

syn_data <- as.data.frame(syn_data)

syn_data$number_employees = 1 + round(200 * qbeta(pnorm(syn_data$number_employees, 
                                                 mean = mean(syn_data$number_employees), 
                                                 sd = sd(syn_data$number_employees)), 
                                                 shape1=1.1, shape2=2))

plot_data <- cbind(df %>% select(number_employees) %>% rename(real_employees = number_employees),
                   syn_data %>% select(number_employees) %>% rename(syn_employees = number_employees))

print(head(plot_data))

plot_data %>%
    ggplot() +
    geom_histogram(aes(x=real_employees), binwidth = 0.3, fill = "green", color = "green", alpha=0.7) +
    geom_histogram(aes(x=syn_employees), binwidth = 0.3, fill = "red", color = "red", alpha=0.7) +
    scale_x_log10()