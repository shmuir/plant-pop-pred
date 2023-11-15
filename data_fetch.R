## Data reading and cleaning ##

library(tidyverse)
library(BIEN)
library(rredlist)
library(janitor)

# leaf photosynthetic rate per leaf area	

lpr <- BIEN_trait_trait("leaf photosynthetic rate per leaf area") %>%
  rename(scientific_name = scrubbed_species_binomial)


redlist <- read_csv("data/redlist_species_data/assessments.csv") %>%
  clean_names()


#setdiff(lpr$scrubbed_species_binomial, redlist$scientific_name)

join <- inner_join(lpr, redlist, by = "scientific_name")



# # Identify token for accessing IUCN API
# 
# rredlist::rl_use_iucn()
# 
# iucn_token <- Sys.getenv("IUCN_KEY")
# 
# # Import all species on IUCN Redlist
# for (i in 0:15) {
#   # Get data from API and assign to variable with a name
#   assign(paste0("species", i), rl_sp(page = i, key = iucn_token))
#   # Get the result data frame from the variable and assign to a new variable with a name
#   assign(paste0("species", i, "_df"), get(paste0("species", i))$result)
# }
# 
# 
# species0 <- rl_sp(page = 0, key = iucn_token)
# species0_df <- species0$result
# 
# all_iucn_species <- bind_rows(species0_df, species1_df, species2_df, species3_df, 
#                               species4_df, species5_df, species6_df, species7_df,
#                               species8_df, species9_df, species10_df, species11_df,
#                               species12_df, species13_df, species14_df, species15_df)
# 
# # Save this as a csv
# #write.csv(all_iucn_species, file.path(dataexp, "all_iucn_species.csv"))
# 
# all_iucn_species <- all_iucn_species %>%  select(c("scientific_name", "category", "main_common_name")) %>% 
#   rename(genus_species = scientific_name)