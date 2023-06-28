library(haven)
library(here)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(viridis)
library(hrbrthemes)

survey <- read_spss(file = here("new-data", "CSBS.sav"))

df <- data.frame(survey)

df <- df %>%
    select(disrupta1, disrupta2, disrupta3, disrupta4, disrupta5, disrupta5,
    disrupta6, disrupta7, disrupta8, disrupta9, disrupta10, disrupta11, 
    disrupta12, disrupta13) %>%
    summarise(disrupta1 = sum(disrupta1, na.rm = TRUE),
              disrupta2 = sum(disrupta2, na.rm = TRUE),
              disrupta3 = sum(disrupta3, na.rm = TRUE),
              disrupta4 = sum(disrupta4, na.rm = TRUE),
              disrupta5 = sum(disrupta5, na.rm = TRUE),
              disrupta6 = sum(disrupta6, na.rm = TRUE),
              disrupta7 = sum(disrupta7, na.rm = TRUE),
              disrupta8 = sum(disrupta8, na.rm = TRUE),
              disrupta9 = sum(disrupta9, na.rm = TRUE),
              disrupta10 = sum(disrupta10, na.rm = TRUE),
              disrupta11 = sum(disrupta11, na.rm = TRUE),
              disrupta12 = sum(disrupta12, na.rm = TRUE),
              disrupta13 = sum(disrupta13, na.rm = TRUE))

plot_data <- data.frame(
  name = c("Ransomware", "Malware", "DoS", "Bank account", "Impersonating", "Phising", "Unauthorised access by staff", "Unauthorised access by stranger", "Ohter", "Don't know", "Unauthorised listening to video or messaging", "Takeover website/social media/email", "Unauthorised access by student"),
  data = c(df$disrupta1, df$disrupta2, df$disrupta3, df$disrupta4, df$disrupta5, df$disrupta6,
           df$disrupta7, df$disrupta8, df$disrupta9, df$disrupta10, df$disrupta11, df$disrupta12,
           df$disrupta13)
)

plot_data <- plot_data %>%
  arrange(desc(data))

plot_data$name <- factor(plot_data$name, levels = plot_data$name)

plot_data %>%
  ggplot(aes(x=name, y=data)) +
  geom_bar(stat="identity") +
  coord_flip() +
  ggtitle("Numbers of attacks by type") +
  ylab("Number of attacks") +
  xlab("Type of attack")