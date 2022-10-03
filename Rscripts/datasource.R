library(tidyverse)

YEARS = seq(from = 2013, to = 2022)

getResults <- function(){
  results <- data.frame()
  for(year in YEARS){
    file <- paste0(year, '/', 'Competition_', year, '.csv')
    cat('Adding results from ', file, '\n')
    r <- read.csv(file, stringsAsFactors = FALSE)
    r$year <- year
    results <- bind_rows(results, r)  
  }
  return(results)
}


getToolsResults <- function(){
  results <- getResults() %>%
    filter(tool != 'manual',
           tool != 'combined')
  return(results)
}