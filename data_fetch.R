## Data reading and cleaning ##

library(tidyverse)
library(BIEN)
library(rredlist)
library(janitor)


# leaf photosynthetic rate per leaf area	

lpr <- BIEN_trait_trait("leaf photosynthetic rate per leaf area") %>%
  rename(scientific_name = scrubbed_species_binomial)  %>%
  mutate(trait_value = as.numeric(trait_value)) %>%
  filter(trait_value < 70)

#leaf carbon content per leaf dry mass

lpr_summary <- lpr %>%
  group_by(scientific_name) %>%
  summarise(avg_photo = mean(trait_value, na.rm = TRUE))



redlist <- read_csv("data/redlist_species_data/assessments.csv") %>%
  clean_names() %>%
  filter(population_trend %in% c("Stable", "Increasing", "Decreasing"),
         redlist_category %in% c("Endangered", "Critically Endangered", "Least Concern", "Vulnerable", "Near Threatened")) %>%
  mutate(pop_trend = case_when(population_trend == "Decreasing" ~ "Decreasing",
                               population_trend %in% c("Stable", "Increasing") ~ "Stable_Inc"),
         pop_trend_binary = case_when(pop_trend == "Decreasing" ~ 1,
                                      pop_trend == "Stable_Inc" ~ 0),
         category = case_when(redlist_category %in% c("Least Concern", "Near Threatened") ~ "Non-Threatened",
                              redlist_category %in% c("Endangered", "Critically Endangered", "Vulnerable") ~ "Threatened"),
         category_binary = case_when(category == "Non-Threatened" ~ 0,
                                     category == "Threatened" ~ 1)) 


#setdiff(lpr$scrubbed_species_binomial, redlist$scientific_name)

join <- inner_join(lpr_summary, redlist)

