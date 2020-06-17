#This Code just update one time per week
library(jsonlite)
library(httr)
library(readxl)
library(tidyverse)
library(R.utils)



#Borrar el archivo para poder guardar uno nuevo y actualizado
#Delete file if it exists
file.remove("database/KoboConabio/Componente2_4.xlsx")
file.remove("database/KoboConabio/Mat_comunicacion.xlsx")

data1 <- GET("https://kcat.conabio.gob.mx/api/v1/forms", authenticate(Passw1, Passw2))
    
data1$status_code
data1$headers$`content-type`

text_content <- httr::content(data1, "text", encoding = "UTF-8")
text_content

#Parse with jsonlite
json_content <- fromJSON(text_content, flatten = T)
head(json_content)
class(json_content)
dim(json_content)
    
    
json_content1 <- json_content %>%
    select(url, formid, title) %>%
    filter(
        title %in% c("Registro de Proyectos. Componentes 2 y 4 (GEF-Agrobiodiversidad)",
                     "Materiales de comunicacion"))


head(json_content1,10)

uno <- paste0(json_content1[1,1], ".xlsx") 
#dir("database/KoboConabio")
#direct2
downloadFile(uno, "dataBase/KoboConabio/Componente2_4.xlsx", username = Passw1, password = Passw2)

dos <- paste0(json_content1[2,1], ".xlsx") 
#dir("database/KoboConabio")
#direct2
downloadFile(dos, "dataBase/KoboConabio/Mat_comunicacion.xlsx", username = Passw1, password = Passw2)
    
    
    
#read this: https://gargle.r-lib.org/
# read this: https://googlesheets4.tidyverse.org/articles/articles/drive-and-sheets.html#coordinating-auth-1
#read this: https://googlesheets4.tidyverse.org/

library(tidyverse)
#library(gargle)
library(googlesheets4)
#library(googledrive)
# Esto sirve para la autorización de google sheets. Se hace la primera vez y 
# después ya no lo vuelve a pedir, sólo confirma si la autorización es para el 
# correo de google asignado    
#gs4_auth()

#Bajar las hojas de excel


file.remove("database/google_drive/tabla_google1.csv")
file.remove("database/google_drive/tabla_google2.csv")
file.remove("database/google_drive/tabla_google3.csv")
file.remove("database/google_drive/tabla_google4.csv")
file.remove("database/google_drive/tabla_google5.csv")
file.remove("database/google_drive/tabla_google6.csv")
file.remove("database/google_drive/tabla_google7.csv")
file.remove("database/google_drive/tabla_google8.csv")
file.remove("database/google_drive/tabla_google9.csv")
    
#_________
#Para e. D.1.1.1.3.0.1 Número de bases de datos
#SIAGRO_Bases
address1 <- c("https://docs.google.com/spreadsheets/d/1vOyDgfaO31YGqHxz8Nbs_KvsPXO_VoCibOJdeR0HFTM/edit#gid=0")
tabla_google1 <- read_sheet(address1, sheet = "Registro")

write_csv(tabla_google1, path = "dataBase/google_drive/tabla_google1.csv", 
           col_names = TRUE)

#_________
#Para e. D.1.1.1.1.0.1 Número de Publicaciones 
#C1_Publicaciones
address <- c("https://docs.google.com/spreadsheets/d/1b7C89VavHfR2OHaM347Mhf9YmiK4RXmuPvxtPUc8u8g/edit#gid=0")
tabla_google2 <- read_sheet(address, sheet = "Publicaciones") %>% 
    select(TIPOPUB, TITULO, AUTOR)

write_csv2(tabla_google2, path = "dataBase/google_drive/tabla_google2.csv", 
          col_names = TRUE)

#_________
#Para e. D.1.1.1.5.0.1 Número de proyectos de investigación participativa 
#C1_Investigacion_Participativa
address <- c("https://docs.google.com/spreadsheets/d/12VOJul7TsonW9G6398AdW9dEzwwCR-kaKSbr7tm-YUk/edit#gid=0")
tabla_google3 <- read_sheet(address, sheet = "Proyectos_Investigacion") 

write_csv2(tabla_google3, path = "dataBase/google_drive/tabla_google3.csv", 
           col_names = TRUE)

#_________
#Para e. D.1.1.1.5.0.3 Número de Publicaciones 
#C1_Publicaciones
address <- c("https://docs.google.com/spreadsheets/d/1b7C89VavHfR2OHaM347Mhf9YmiK4RXmuPvxtPUc8u8g/edit#gid=0")
tabla_google2 <- read_sheet(address, sheet = "Publicaciones") %>% 
    select(TIPOPUB, TITULO, AUTOR)

write_csv2(tabla_google2, path = "dataBase/google_drive/tabla_google2.csv", 
           col_names = TRUE)


#_________
#Para e. D.1.1.1.4.0.1 Protocolo diseñado, adoptado y aprobado 
#SIAGRO_Protocolo
address <- c("https://docs.google.com/spreadsheets/d/17b9aGdeb3bS6N3aBXf3o5Cfm0o3DUqQOoP1n-GtuYLs/edit#gid=0")
tabla_google4 <- read_sheet(address, sheet = "Fases") 

write_csv2(tabla_google4, path = "dataBase/google_drive/tabla_google4.csv", 
           col_names = TRUE)


#_________
#Para e. D.1.1.1.2.0.1 Sistema integral de información
#SIAGRO_Desarrollo
address <- c("https://docs.google.com/spreadsheets/d/1xwLDcVh-mzbi063N5RvUnbJxrYgYaMiDvEuinGVUjoU/edit#gid=0")
tabla_google5 <- read_sheet(address, sheet = "Fases") 

write_csv2(tabla_google5, path = "dataBase/google_drive/tabla_google5.csv", 
           col_names = TRUE)

#_________
#Para e. D.1.1.0.0.0.1 Número de actores institucionales clave que ha adoptado y están usando el SIAgroBD
#SIAGRO_Registro
address <- c("https://docs.google.com/spreadsheets/d/1mQCQIMidx1dq68KRYpzkCdHpft9Ja25LS_uPg7DD3fI/edit#gid=0")
tabla_google6 <- read_sheet(address, sheet = "Registro") 

write_csv2(tabla_google6, path = "dataBase/google_drive/tabla_google6.csv", 
           col_names = TRUE)

#_________
#Para e. E.0.1.1.3.0.1 Protocolo para la valoración rural participativa
#SIAGRO_Registro
address <- c("https://docs.google.com/spreadsheets/d/1e2vlVnHEZvnaBBmEjTHeyogiIKzYlVTrZZsUS91ov5Y/edit#gid=0")
tabla_google7 <- read_sheet(address, sheet = "Protocol_Participativo") 

write_csv2(tabla_google7, path = "dataBase/google_drive/tabla_google7.csv", 
           col_names = TRUE)

#_________
#Para e. E.0.1.1.5.0.1 Protocolo de valoración económica
#C1_Protocolo_Valoracion_Participativa
address <- c("https://docs.google.com/spreadsheets/d/1JQg9rkGNpTOP3UOKCDU-R_V8HweMt5xQ5XfcHJlhaLg/edit#gid=0")
tabla_google8 <- read_sheet(address, sheet = "Protocol_Economico") 

write_csv2(tabla_google8, path = "dataBase/google_drive/tabla_google8.csv", 
           col_names = TRUE)


#   #_________
#   #Para e. E.0.1.1.1.0.2 Materiales de comunicacion
#   #SIAGRO_Registro
#   address <- c("https://docs.google.com/spreadsheets/d/1JQg9rkGNpTOP3UOKCDU-R_V8HweMt5xQ5XfcHJlhaLg/edit#gid=0")
#   tabla_google8 <- read_sheet(address, sheet = "Protocol_Economico") 
#   
#   write_csv2(tabla_google8, path = "dataBase/google_drive/tabla_google8.csv", 
#              col_names = TRUE)
#   
   
#_________
#Para e. E.0.1.1.1.0.1 Estrategia de comunicacion
#SIAGRO_Registro
address <- c("https://docs.google.com/spreadsheets/d/1rdhCyMbsAneaL6oce6_SvK_d900JWz7Ku5TOPQ5Op2w/edit#gid=0")
tabla_google9 <- read_sheet(address, sheet = "Fases") 

write_csv2(tabla_google9, path = "dataBase/google_drive/tabla_google9.csv", 
           col_names = TRUE)

