library(tidyverse)
library(ggplot2)

source('Rscripts/datasource.R')

results <- getToolsResults()

results %>%
  ggplot(aes(x=tool, y=avgcovi, fill = tool)) + 
    geom_boxplot() + 
    facet_grid(year ~ ., scales = 'free_y') +
    coord_flip()
