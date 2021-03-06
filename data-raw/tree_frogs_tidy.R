# this script imports and cleans raw data from Julie Jung's work on
# how red-eyed tree frogs sense predator vibrations

# load packages
library(tidyverse)
library(janitor)
library(usethis)
  
# read in raw data
tree_frogs_raw <- read_csv("data-raw/tree_frogs_raw.csv")

# set randomness (for reordering)
set.seed(2)

# some filtering + selecting :-)
tree_frogs <-
  tree_frogs_raw %>%
  dplyr::rename_all(janitor::make_clean_names) %>%
  dplyr::filter(
    experiment == "Individual"
  ) %>%
  dplyr::transmute(
    clutch = factor(clutch),
    treatment = case_when(
      treatment == "G" ~ "gentamicin",
      treatment == "NT" ~ "control",
      TRUE ~ NA_character_
    ),
    reflex = case_when(
      age_groups_four == "4d_lowVOR" ~ "low",
      age_groups_four == "4d_highVOR" ~ "mid",
      age_groups_four %in% c("4d", "5d") ~ "full",
    ),
    reflex = factor(reflex, levels = c("low", "mid", "full")),
    age = 
      (age_days * 86400) + (stimulus_h * 3600) + (stimulus_m * 60) + stimulus_s,
    t_o_d = case_when(
      stimulus_h <= 5 | stimulus_h >= 20 ~ "night",
      stimulus_h > 5 & stimulus_h < 12 ~ "morning",
      stimulus_h >= 12 & stimulus_h < 20 ~ "afternoon",
      TRUE ~ NA_character_
    ), 
    hatched = case_when(
      response == 1 ~ "yes",
      response == 0 ~ "no",
      TRUE ~ NA_character_
    ),
    latency = 
      ((age_days * 86400) + (hatch_h * 3600) + (hatch_m * 60) + hatch_s) - age
  ) %>%
  slice_sample(n = nrow(.))

usethis::use_data(tree_frogs, internal = FALSE, overwrite = TRUE)
