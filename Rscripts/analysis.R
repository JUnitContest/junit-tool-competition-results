library(tidyverse)
library(ggplot2)
library(tsutils)

source('Rscripts/datasource.R')

COLOR_PALETTE = "RdYlBu" # Color blind friendly colors (http://colorbrewer2.org/)
SIGNIFICANCE_LEVEL = 0.05

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

# Plotting EvoSuite and Randoop results
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


# Compare Randoop and EvoSuite results
results %>%
  filter(tool %in% c('evosuite', 'randoop')) %>%
  mutate(instruction = 1 - if_else(is.na(avgcovi), 0, avgcovi)) %>%
  select(year, benchmark, budget, tool, instruction) %>%
  pivot_wider(names_from = tool, values_from = instruction) %>%
  select(-year, -benchmark, -budget) %>%
  as.matrix() %>%
  nemenyi(plottype = "vmcb", conf.level = 1.0 - SIGNIFICANCE_LEVEL)

results %>%
  filter(tool %in% c('evosuite', 'randoop')) %>%
  mutate(branch = 1 - if_else(is.na(avgcovb), 0, avgcovb)) %>%
  select(year, benchmark, budget, tool, branch) %>%
  pivot_wider(names_from = tool, values_from = branch) %>%
  select(-year, -benchmark, -budget) %>%
  as.matrix() %>%
  nemenyi(plottype = "vmcb", conf.level = 1.0 - SIGNIFICANCE_LEVEL)

results %>%
  filter(tool %in% c('evosuite', 'randoop')) %>%
  mutate(mutation = 1 - if_else(is.na(avgcovm), 0, avgcovm)) %>%
  select(year, benchmark, budget, tool, mutation) %>%
  pivot_wider(names_from = tool, values_from = mutation) %>%
  select(-year, -benchmark, -budget) %>%
  as.matrix() %>%
  nemenyi(plottype = "vmcb", conf.level = 1.0 - SIGNIFICANCE_LEVEL)
  
