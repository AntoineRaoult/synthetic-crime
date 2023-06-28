library(haven)
library(here)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(viridis)

survey <- read_spss(file = here("new-data", "CSBS.sav"))

df <- data.frame(survey)

df <- df %>%
  mutate(year = ifelse(year == 8, 7, year)) %>%
  mutate(questtype = ifelse(questtype > 3, 3, questtype)) %>%
  select(year, priority, questtype) %>%
  filter(priority != -97) %>%
  group_by(questtype, year) %>%
  summarise(mean_priority = mean(priority, na.rm = TRUE)) %>%
  mutate(year = year + 2015) %>%
  mutate(questtype = ifelse(questtype == 1, "Private", ifelse(questtype == 2, "Charity", "Education"))) %>%
  mutate(mean_priority = 4 - mean_priority)

df %>%
  ggplot(aes(x=year,y=mean_priority, group=questtype, color=questtype)) +
  geom_line() +
  scale_color_viridis(discrete = TRUE) +
  geom_point() +
  ggtitle("Mean priority score by year") +
  ylab("Mean priority score") +
  xlab("Year")