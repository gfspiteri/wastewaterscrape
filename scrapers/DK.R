library(httr2)
library(rvest)

wwPage <- 'https://www.ssi.dk/sygdomme-beredskab-og-forskning/sygdomsovervaagning/c/covid-19---spildevandsovervaagning'

wwFile <- read_html(wwPage) |> 
  html_elements(xpath = '(//*[@class="card-body card-text rte"])[2]/ul/li[1]/h5/a') |> 
  html_attr('href')

download.file(wwFile, 'temp/dk.zip')

unzip('temp/dk.zip', exdir = 'temp')

nationalFile <- list.files('temp/SARS-CoV-2 koncentration', pattern = '^.*dk_wastewater_data\\.csv$') 

regionalFile <- list.files('temp/SARS-CoV-2 koncentration', pattern = '^.*region_wastewater_data\\.csv$') 
  
nationalDataset <- read.csv(paste0('temp/SARS-CoV-2 koncentration/', nationalFile))

regionalDataset <- read.csv(paste0('temp/SARS-CoV-2 koncentration/', regionalFile))

write.csv(nationalDataset, 'datasetsRaw/DKNational.csv')

write.csv(regionalDataset, 'datasetsRaw/DKRegional.csv')

file.remove('temp/dk.zip')
unlink('temp/*', force = T, recursive = T)
