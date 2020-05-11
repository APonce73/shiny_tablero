library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(readxl)
library(plotly)



server <- function(input, output, session) {
    
    neutro <- "light-blue"
    
  #  ind <- read_excel("BaseDatosIndicadores.xlsx")
    
    # DIMENSIÓN INFORMARCIÓN (Componente 1)
    
    # INDICADOR: INVOLUCRADOS INSTITUCIONALES
    
    #siagro_registro <- "SIAGRO_Registro.xlsx"  
    # reactive_siagro_registro <- reactiveFileReader(
    #   intervalMillis = 1000,
    #   session = session,
    #   filePath = siagro_registro,
    #   readFunc = function(filePath) {
    #     read_excel(url(filePath))})
    
    reactive_siagro_registro <- read_excel("database/SIAGRO_Registro.xlsx")
    
    involucrados <- c("CONANP", "CONABIO", "ECOSUR", "GIZ", "INCMNSZ", "INIFAP", "INAES", "INPI", "FAO", "SADER", "BIENESTAR", "SDS", "SEMARNAT", "SNITT", "UNAM")
    
    anio <- 2020#format(Sys.Date(), "%Y")
    
    siagro_porcentaje <- reactive_siagro_registro %>%
        mutate(ic = reactive_siagro_registro$ACRINST %in% involucrados) %>%
        filter(ic == TRUE) %>%
        group_by(ANIO) %>%
        summarise(porcentaje = n()/length(involucrados)*100)
    
    siagro_ult_anio <- filter(siagro_porcentaje, ANIO == anio)
    
    siagro_plot <- ggplot(siagro_porcentaje, aes(x = as.factor(ANIO), y = porcentaje, text = paste("Año : ", ANIO, "<br>Porcentaje: ", round(porcentaje, digits = 1)))) +
        geom_bar(stat = "identity", fill = "deepskyblue2") +
        ylim(0,100) +
        xlab("Año") +
        ylab("Porcentaje") +
        theme_classic()
    
    output$siagro_involucrados <- renderPlotly({
        ggplotly({
            siagro_plot
        }, tooltip = "text") %>% config(displayModeBar = FALSE)
    })
    
    output$valueBoxSiagro <- renderValueBox({
        color <- if_else(siagro_ult_anio$porcentaje < 25, "red",
                         if_else(siagro_ult_anio$porcentaje < 75, "yellow","green"))
        valueBox(
            width = 4,
            value = paste(siagro_ult_anio$porcentaje, "%"), 
            subtitle = "Meta final: 75%",
            color = color,
            icon = icon("bullseye")
        )
    })
    
    # INDICADOR: REPORTES
    reactive_publicaciones <- read_excel("database/Publicaciones.xlsx")
    
    reportes <- reactive_publicaciones %>%
        mutate(ANIO = format(reactive_publicaciones$FECHA, format = "%Y")) %>%
        filter(RECOM == "Sí") %>%
        group_by(ANIO) %>%
        summarise(Total = n())  
    
    reportes_plot <- ggplot(reportes, aes(x = as.factor(ANIO), y = as.integer(Total), text = paste("Año : ", ANIO, "<br>Publicaciones: ", Total))) +
        geom_bar(stat = "identity", fill = "deepskyblue2") +
        ylim(0,10) +
        xlab("Año") +
        ylab("Número de reportes") +
        theme_classic()
    
    output$reportes <- renderPlotly({
        ggplotly({
            reportes_plot
        }, tooltip = "text") %>% config(displayModeBar = FALSE)
    })
    
    output$valueBoxReportesIntermedia <- renderValueBox({
        meta <- reportes %>% filter(ANIO <= 2020) %>% summarise(sum(Total))
        
        color <- if_else(meta < 1, "red","green")
        valueBox(
            width = 4,
            value =  meta, 
            subtitle = "Meta intermedia: 1 reporte",
            color = color,
            icon = icon("bullseye")
        )
    })
    output$valueBoxReportesFinal <- renderValueBox({
        meta <- sum(reportes$Total)
        
        color <- if_else(meta < 1, "red",
                         if_else(meta < 3, "yellow","green"))
        valueBox(
            width = 4,
            value = meta, 
            subtitle = "Meta final: 3 reportes",
            color = color,
            icon = icon("bullseye")
        )
    })
    
    # INDICADOR: DESARROLLO DEL SIAGRO
    
    reactive_siagro_desarrollo <- read_excel("database/SIAGRO_Desarrollo.xlsx")
    
    output$valueBoxDesarrolloIntermedia <- renderValueBox({
        color <- if_else(!is.na(reactive_siagro_desarrollo[2,3]), "green", "yellow")
        valueBox(
            width = 4,
            value = if_else(color == "yellow", "Sistema en diseño", "Sistema diseñado"), 
            subtitle = "Meta intermedia: Sistema diseñado",
            color = color,
            icon = icon("bullseye")
        )
    })
    
    output$valueBoxDesarrolloFinal <- renderValueBox({
        color <- if_else(!is.na(reactive_siagro_desarrollo[4,3]), "green",
                         if_else(!is.na(reactive_siagro_desarrollo[3,2]), "yellow", "red"))
        valueBox(
            width = 4,
            value = if_else(color == "green","Sistema implementado", 
                            if_else(color == "yellow", "Sistema en pruebas",
                                    if_else(color == "red" & !is.na(reactive_siagro_desarrollo[2,3]), "Sistema diseñado", "Sistema en diseño"))), 
            subtitle = "Meta final: Sistema implementado y adoptado",
            color = color,
            icon = icon("bullseye")
        )
    })
    
    output$tablaDesarrollo <- DT::renderDataTable({
        DT::datatable(reactive_siagro_desarrollo)
    })
    
    # INDICADOR: TRANSFORMACIÓN DE BASES DE DATOS
    reactive_siagro_bases <- read_excel("database/SIAGRO_Bases.xlsx")
    
    bd_proc <- reactive_siagro_bases %>%
        filter(ESTATUS == "En procesamiento") %>%
        summarise("Total en procesamiento" = n())
    
    bd_trans <-reactive_siagro_bases %>%
        filter(ESTATUS == "Transformada") %>%
        summarise("Total transformadas" = n())
    
    output$valueBoxBasesIntermedia <- renderValueBox({
        color <- if_else(bd_proc + bd_trans < 6, "red",if_else(bd_proc + bd_trans < 12, "orange", "green"))
        valueBox(
            width = 4,
            value = paste(bd_proc, "bases en procesamiento"), 
            subtitle = "Meta intermedia: 12 bases en procesamiento",
            color = color,
            icon = icon("bullseye")
        )
    })
    
    output$valueBoxBasesFinal <- renderValueBox({
        color <- if_else(bd_trans < 6, "red",if_else(bd_trans < 12, "orange", "green"))
        valueBox(
            width = 4,
            value = paste(bd_trans, "bases transformadas"), 
            subtitle = "Meta final: 12  bases transformadas",
            color = color,
            icon = icon("bullseye")
        )
    })  
    
    output$tablaBases <- DT::renderDataTable({
        DT::datatable(reactive_siagro_bases %>%
                          select(Base_de_datos = CVE_BD, Estatus = ESTATUS))
    })
    
    # INDICADOR: PROTOCOLO DEL SIAGRO
    
    reactive_siagro_protocolo <- read_excel("database/SIAGRO_Protocolo.xlsx")
    
    output$valueBoxProtocoloIntermedia <- renderValueBox({
        color <- if_else(!is.na(reactive_siagro_protocolo[2,3]), "green", "yellow")
        valueBox(
            width = 4,
            value = if_else(color == "yellow", "Protocolo en diseño", "Protocolo diseñado"), 
            subtitle = "Meta intermedia: Protocolo diseñado",
            color = color,
            icon = icon("bullseye")
        )
    })
    
    output$valueBoxProtocoloFinal <- renderValueBox({
        color <- if_else(!is.na(reactive_siagro_protocolo[4,3]), "green",
                         if_else(!is.na(reactive_siagro_protocolo[3,2]), "yellow", "red"))
        valueBox(
            width = 4,
            value = if_else(color == "green","Protocolo adoptado", 
                            if_else(color == "yellow", "Protocolo aprobado",
                                    if_else(color == "red" & !is.na(reactive_siagro_protocolo[2,3]), "Protocolo diseñado", "Protocolo en diseño"))), 
            subtitle = "Meta final: Protocolo adoptado",
            color = color,
            icon = icon("bullseye")
        )
    })
    
    output$tablaProtocolo <- DT::renderDataTable({
        DT::datatable(reactive_siagro_protocolo)
    })
    
    # INDICADOR: INVESTIGACIONES
    reactive_siagro_inv <- read_excel("database/SIAGRO_Investigaciones.xlsx")
    
    
    # INDICADOR: AREAS DE INTERVENCIÓN
    
    areas <- c("Ciudad de México", "Chiapas", "Chihuahua", "Michoacán", "Oaxaca", "Yucatán")
    
    inv_areas_int <- reactive_siagro_inv %>%
        filter(!is.na(INICIO) & INICIO < ymd("2020-01-01")) %>%
        distinct(Entidades) %>%
        pull(Entidades)
    
    iai <- sum(inv_areas_int %in% areas)
    
    inv_areas_fin <- reactive_siagro_inv %>%
        filter(!is.na(INICIO) & INICIO < ymd("2022-12-31")) %>%
        distinct(Entidades) %>%
        pull(Entidades)
    
    iaf <- sum(inv_areas_fin %in% areas)
    
    output$valueBoxAreasIntermedia <- renderValueBox({
        color <- if_else(iai < 2, "red",if_else(iai < 4, "orange", "green"))
        valueBox(
            width = 4,
            value = paste(iai, "áreas"), 
            subtitle = "Meta intermedia: 4 áreas",
            color = color,
            icon = icon("bullseye")
        )
    })
    
    output$valueBoxAreasFinal <- renderValueBox({
        color <- if_else(iaf < 4, "red",if_else(iaf < 5, "orange", "green"))
        valueBox(
            width = 4,
            value = paste(iaf, "áreas"), 
            subtitle = "Meta final: 6 áreas",
            color = color,
            icon = icon("bullseye")
        )
    })  
    
    # INDICADOR: PUBLICACIONES
    
    publicaciones_inv <- reactive_publicaciones %>%
        mutate(ANIO = format(reactive_publicaciones$FECHA, format = "%Y")) %>%
        filter(PROYINV == "Sí") %>%
        group_by(ANIO) %>%
        summarise(Total = n())
    
    publicaciones_plot <- ggplot(publicaciones_inv, aes(x = as.factor(ANIO), y = as.integer(Total), text = paste("Año : ", ANIO, "<br>Publicaciones: ", Total))) +
        geom_bar(stat = "identity", fill = "deepskyblue2") +
        ylim(0,10) +
        xlab("Año") +
        ylab("Número de publicaciones") +
        theme_classic()
    
    output$publicaciones <- renderPlotly({
        ggplotly({
            publicaciones_plot
        }, tooltip = "text") %>% config(displayModeBar = FALSE)
    })
    
    output$valueBoxPublicacionesIntermedia <- renderValueBox({
        color <- if_else(anio < 2020, neutro, if_else(sum(publicaciones_inv$Total) < 1, "orange","green"))
        valueBox(
            width = 4,
            value = 1, 
            subtitle = "Meta intermedia",
            color = color,
            icon = icon("bullseye")
        )
    })
    output$valueBoxPublicacionesFinal <- renderValueBox({
        color <- if_else(anio < 2021, neutro, if_else(sum(publicaciones_inv$Total) < 3, "orange","green"))
        valueBox(
            width = 4,
            value = 3, 
            subtitle = "Meta final",
            color = color,
            icon = icon("bullseye")
        )
    })
}
