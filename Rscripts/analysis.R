library(tidyverse)
library(ggplot2)

source('Rscripts/datasource.R')

COLOR_PALETTE = "RdYlBu" # Color blind friendly colors (http://colorbrewer2.org/)

results <- getToolsResults()

# Plotting averaged coverage over the years
results %>%
  group_by(year, tool) %>%
  summarise(instruction = mean(avgcovi), branch = mean(avgcovb), mutation = mean(avgcovm)) %>%
  gather("coverage", "average", instruction, branch, mutation) %>%
  ggplot(aes(x=year, y=average, color = tool)) + 
    geom_line(aes(linetype = tool)) +
    geom_point(aes(shape = tool ), size=2.5) + 
    scale_shape_manual(values=1:nlevels(results$tool)) +
    scale_linetype_manual(values=1:nlevels(results$tool)) +
    ylab("averaged coverage") +
    scale_x_continuous(breaks = YEARS) +
    facet_grid(coverage ~ .)
ggsave('plots/averages-coverage-per-year.pdf', width = 180, height = 150, units = 'mm')



results %>%
  filter(tool %in% c('evosuite', 'randoop')) %>%
  rename(instruction = avgcovi, branch = avgcovb, mutation = avgcovm) %>%
  gather("coverage", "average", instruction, branch, mutation) %>%
  ggplot(aes(x=factor(year), y=average)) +
    geom_boxplot() +
    stat_summary(fun="mean", color="blue", shape=18) +
    xlab("year") +
    ylab("averaged coverage per class") +
    facet_grid(coverage ~ tool)
ggsave('plots/coverages-per-year-evosuite-randoop.pdf', width = 200, height = 150, units = 'mm')
