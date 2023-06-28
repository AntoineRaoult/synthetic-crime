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

rm(list=c("survey", "df", "charities", "mean_income", "mean_contry", "mean_year", "number_charities", "cor", "syn_res", "sigma", "plot_data"))

survey <- read_spss(file = here("new-data", "CSBS.sav"))


df <- data.frame(survey)

charities <- df %>%
    filter(questtype == 2 & income != -97 & sizea != -97) %>%
    select(income, country, year, sizea) %>%
    rename(employees = sizea)

mean_income <- mean(charities$income, na.rm = TRUE)
mean_contry <- mean(charities$country, na.rm = TRUE)
mean_year <- mean(charities$year, na.rm = TRUE)
mean_employees <- mean(charities$employees, na.rm = TRUE)

print(c(mean_income, mean_contry, mean_year, mean_employees))

number_charities <- nrow(charities)

cor <- cor(charities, use = "pairwise.complete.obs")

syn_res <- data.frame()

sigma <- try(compute.sigma.star(no.bin=0, no.nor=4,
                                #prop.vec.bin = as.numeric(c()),
                                corr.mat = cor),
             silent=TRUE)

syn_res <- try(jointly.generate.binary.normal(no.rows = nrow(charities),
                                    no.bin = 0, no.nor = 4,
                                    #prop.vec.bin = as.numeric(c()),
                                    mean.vec.nor = c(mean_income, mean_contry, mean_year, mean_employees),
                                    var.nor = c(mean_income^2, mean_contry^2, mean_year^2, mean_employees^2),
                                    sigma_star = sigma$sigma_star,
                                    continue.with.warning=TRUE),
                        silent=TRUE)

syn_res <- as.data.frame(syn_res)


syn_res <- syn_res %>%
    rename(syn_income = V1,
           syn_country = V2,
           syn_year = V3,
           syn_employees = V4) %>%
           mutate(syn_income = round(norm2trunc(syn_income, min = 1, max = 5)),
                syn_country = round(norm2trunc(syn_country, min = 1, max = 3)),
                syn_year = round(norm2trunc(syn_year, min = 1, max = 7)),
                syn_employees = round(norm2trunc(syn_employees, min=charities$employees, max=charities$employees)))

print(head(syn_res))

syn_mean_income <- mean(syn_res$syn_income, na.rm = TRUE)
syn_mean_country <- mean(syn_res$syn_country, na.rm = TRUE)
syn_mean_year <- mean(syn_res$syn_year, na.rm = TRUE)
syn_mean_employees <- mean(syn_res$syn_employees, na.rm = TRUE)

print(c(syn_mean_income, syn_mean_country, syn_mean_year, syn_mean_employees))