#Data for KoboConabio 

library(tidyverse)
library(readxl)
library(rio)
library(R.utils)
library(ggrepel)
library(openxlsx)

#This Code just update one time per week
#    library(jsonlite)
#    library(httr)
#    data1 <- GET("https://kcat.conabio.gob.mx/api/v1/forms", authenticate(Passw1, Passw2))
#    
#    data1$status_code
#    data1$headers$`content-type`
#    
#    text_content <- httr::content(data1, "text", encoding = "UTF-8")
#    text_content
#    
#    #Parse with jsonlite
#    json_content <- fromJSON(text_content, flatten = T)
#    head(json_content)
#    class(json_content)
#    dim(json_content)
#    
#    
#    json_content1 <- json_content %>%
#        select(url, formid, title) %>%
#        filter(
#            title == "Registro de Proyectos. Componentes 2 y 4 (GEF-Agrobiodiversidad)")
#    
#    
#    head(json_content1,10)
#    
#    uno <- paste0(json_content1[1,1], ".xlsx") 
#    file.remove("dataBase/KoboConabio/Componente2_4.xlsx")
#    dir("database/KoboConabio")
#    #direct2
#    downloadFile(uno, "dataBase/KoboConabio/Componente2_4.xlsx", username = Passw1, password = Passw2)
#    