# LOAD LIBRARIES ----
library(shiny)
library(shinydashboard)
library(tidyverse)
library(leaflet)
library(shinycssloaders)
library(markdown)
library(shinyWidgets)
library(dplyr)
library(DT)
library(janitor)
library(shinythemes)
library(stringr)
library(shinyjs)

# load data
sensor_range_df <- read_csv("data/Sensor Range.csv") %>% clean_names()
platform_range_df <- read_csv("data/Platform Range.csv") %>% clean_names()
iuu_type_index <- read_csv("data/IUU Type Index.csv") %>% clean_names() %>% 
  select(!detection_area)
satellites <- read_csv("data/satellites.csv") %>% clean_names()
characteristics <- read_csv("data/characteristics.csv") %>% clean_names()

# Loading new merged index
#platform_sensor_coverage_area_df <- read_csv(here("data", "platform_sensor_coverage_area.csv")) %>% 
#round(., 0)
#merged_index_df <- merge(iuu_type_index, platform_sensor_coverage_area_df, by.x = "granularity_index", by.y = "index")

# LOADING NEWEST MERGED INDEX
merged_index_df <- read_csv("data/merged_index_removed_bad_combos.csv") # updated this 4/3

iuu_type <- colnames(merged_index_df)[2:11]


# Load bin area ranges
bin_ranges_df <- read_csv("data/bin_ranges.csv")

# load sensor platform combinations with cost column
# sensor_platform_combinations_cost_df <- read_csv("data/sensor_platform_removed_bad_pairings.csv")
# merges sensor and platform, creating new combined_name column
# sensor_platform_combinations_cost_df$sensor_platform <- with(sensor_platform_combinations_cost_df, paste(sensor, "by", platform))

# Load cost ranges
cost_ranges_df <- read_csv("data/cost_ranges.csv")

# load combination matrix
combination_matrix <- read_csv("data/combination_matrix.csv")