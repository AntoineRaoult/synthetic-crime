library(here)
library(dplyr)

load(here(".", "total"))

#split in seven files to allow upload onto Github
syn_res_OA.a <- total %>% filter(ID <= 8010845)
syn_res_OA.b <- total %>% filter(ID >  8010845 & ID <= 16021690)
syn_res_OA.c <- total %>% filter(ID >  16021690 & ID <= 24032535)
syn_res_OA.d <- total %>% filter(ID >  24032535 & ID <= 32043380)
syn_res_OA.e <- total %>% filter(ID >  32043380 & ID <= 40054225)
syn_res_OA.f <- total %>% filter(ID >  40054225 & ID <= 48065070)
syn_res_OA.g <- total %>% filter(ID >  48065070 & ID <= 56075912)

#save synthetic UK population as RData
save(syn_res_OA.a, file = here("data", "synthetic_population_a.RData"))
save(syn_res_OA.b, file = here("data", "synthetic_population_b.RData"))
save(syn_res_OA.c, file = here("data", "synthetic_population_c.RData"))
save(syn_res_OA.d, file = here("data", "synthetic_population_d.RData"))
save(syn_res_OA.e, file = here("data", "synthetic_population_e.RData"))
save(syn_res_OA.f, file = here("data", "synthetic_population_f.RData"))
save(syn_res_OA.g, file = here("data", "synthetic_population_g.RData"))
