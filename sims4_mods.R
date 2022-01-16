# ModtheSims
# Sims 4 Picked Mods
# https://modthesims.info/downloads/ts4/38/page/1/?showType=1&t=picked&csort=0

library(dplyr)
library(rvest)
library(stringr)

`%not in%` <- Negate(`%in%`)
last_updated <- Sys.Date()

for(i in 1:12){
  print(i)
  url <- paste0('https://modthesims.info/downloads/ts4/38/page/',i,'/?showType=1&t=picked&csort=0')
  html <- read_html(url)
  
  mod_image <- html %>% html_nodes('.featuredimage') %>% html_attr('src')
  if(i==7){
    mod_image <- c(mod_image[1],'//thumbs.modthesims.info/getimage.php?file=1641910',mod_image[2:length(mod_image)])
  }
  mod_image <- paste0('https:',mod_image)
  
  
  mod_title <- html %>% html_nodes('.downloadtitle') %>% html_nodes('a') %>% html_text()
  mod_url <- html %>% html_nodes('.downloadtitle') %>% html_nodes('a') %>% html_attr('href')
  mod_url <- paste0('https://modthesims.info/',mod_url)
  
  mod_creator <- html %>% html_nodes('.downloadcreator') %>% html_nodes('a') %>% html_text()
  mod_creator_url <- html %>% html_nodes('.downloadcreator') %>% html_nodes('a') %>% html_attr('href')
  mod_creator_url <- paste0('https://modthesims.info/',mod_creator_url)
  
  
  update_parent_node <- html %>% html_nodes('.downloadcreator')
  update_child_node <- html %>% html_nodes('.downloadcreator') %>% html_nodes('a')
  xml_remove(update_child_node)
  
  mod_timestamp <- update_parent_node %>% html_text(trim=TRUE)
  mod_timestamp <- substr(mod_timestamp,5,999)
  
  mod_stats <- html %>% html_nodes('.downloadCardFooterIcons') 
  mod_stats_to_exclude <- html %>% html_nodes('.downloadCardFooterIcons') %>% html_nodes('.dropdown')
  xml_remove(mod_stats_to_exclude)
  mod_comments_views_and_favs <- mod_stats %>% html_text(trim=TRUE)
  
  mod_categories <- html %>% html_nodes('.forumtitles') %>% html_text(trim=TRUE)
  mod_categories <- gsub('By Function\n» ','',mod_categories)
  
  entry <- data.frame(
    title=mod_title,
    url=mod_url,
    image=mod_image,
    creator=mod_creator,
    creator_url=mod_creator_url,
    timestamp=mod_timestamp,
    comments_views_and_favourites=mod_comments_views_and_favs,
    categories=mod_categories,
    source_url=url,
    last_updated=last_updated,
    stringsAsFactors = F)
  
  if(i == 1){
    mod_df <- entry
  }
  if(i > 1){
    mod_df <- rbind(mod_df,entry)
  }
  Sys.sleep(30)
  
}

write.csv(mod_df,'sims4_mods_raw.csv',row.names = F)

