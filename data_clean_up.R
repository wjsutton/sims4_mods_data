library(dplyr)
#library(rvest)
library(stringr)

`%not in%` <- Negate(`%in%`)

df <- read.csv('sims4_mods_raw.csv',stringsAsFactors = F)

df[,c('comments','views','favourites')] <- trimws(str_split_fixed(df$comments_views_and_favourites, "\n ", 3))

df$comments <- ifelse(grepl('k',df$comments),as.numeric(gsub('k','',df$comments))*1000,as.numeric(df$comments))
df$views <- ifelse(grepl('k',df$views),as.numeric(gsub('k','',df$views))*1000,as.numeric(df$views))
df$favourites <- ifelse(grepl('k',df$favourites),as.numeric(gsub('k','',df$favourites))*1000,as.numeric(df$favourites))

df[,c('broad category','category','subcategory')] <- trimws(str_split_fixed(df$categories, "\n»", 3))


df[,c('released','last_mod_update')] <- trimws(str_split_fixed(df$timestamp, "\n, updated", 2))

df$released <- trimws(str_replace(df$released, " at.*",''))
df$last_mod_update <- trimws(str_replace(df$last_mod_update, " at.*",''))

df <- df[ , (names(df) %not in% c('timestamp','categories','comments_views_and_favourites'))]

write.csv(df,'sim4_mods_cleaned.csv',row.names = F)
