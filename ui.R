library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(readxl)
library(plotly)



header <- dashboardHeader(
  title = "Proyecto Agrobiodiversidad Mexicana",
  titleWidth = 450)


sidebar <- dashboardSidebar(sidebarMenu(
  # Creacion de menus por componente
  menuItem(
    text = "Informacion",
    tabName = "informacion",
    icon = icon("info-circle"),
    menuSubItem(text = "SiagroBD",
                tabName = "siagrobd"),
    menuSubItem(text = "Comunicación",
                tabName = "comunicacion")
  ),
  menuItem(
    text = "Políticas públicas",
    tabName = "politicas",
    icon = icon("handshake")
  ),
  menuItem(
    text = "Capacidades locales",
    tabName = "capacidades",
    icon = icon("seedling")
  ),
  menuItem(
    text = "Mercado",
    tabName = "mercado",
    icon = icon("comments-dollar")
  )
))


body <- dashboardBody(
  # Create a tabBox
  tabItems(
    tabItem(
      tabName = "informacion",
      ),
    tabItem(
      tabName = "siagrobd",
      tabBox(
        width = 12,
        tabPanel(
          title = "Involucrados institucionales",
          fluidRow(
            valueBox(
              width = 4,
              value = 0, 
              subtitle = "Linea base",
              color = "light-blue",
              icon = icon("bullseye")
            ),
            valueBox(
              width = 4,
              value = 0, 
              subtitle = "Meta intermedia: 0 %",
              color = "light-blue",
              icon = icon("bullseye")
            ),
            valueBoxOutput(
              "valueBoxSiagro"
            )
          ),
          fluidRow(
            box(
              width = 8,
              title = "Porcentaje de involucrados institucionales clave que adoptan y utilizan el SIAgroBD",
              plotlyOutput(
               outputId = "siagro_involucrados",
               inline = TRUE)
            )
          )
        ),
        tabPanel(
          title = "Reportes",
          fluidRow(
            valueBox(
              width = 4,
              value = 0, 
              subtitle = "Linea base",
              color = "light-blue",
              icon = icon("bullseye")
            ),
            valueBoxOutput(
              "valueBoxReportesIntermedia"
            ),
            valueBoxOutput(
              "valueBoxReportesFinal"
            )
          ),
          fluidRow(
            box(
              width = 8,
              title = "Número de reportes de análisis y síntesis para la toma de decisiones",
              plotlyOutput(
                outputId = "reportes",
                inline = TRUE)
            )
          )  
        ),
        tabPanel(
          title = "Desarrollo del SIAgro",
          fluidRow(
            valueBox(
              width = 4,
              value = 0, 
              subtitle = "Linea base",
              color = "light-blue",
              icon = icon("bullseye")
            ),
            valueBoxOutput(
              "valueBoxDesarrolloIntermedia"
            ),
              valueBoxOutput(
                "valueBoxDesarrolloFinal"
              )            
          ),
          fluidRow(
            box(
              width = 8,
              title = "Estado de avance en el desarrollo del SIAgro",
              DT::dataTableOutput(
                outputId = "tablaDesarrollo"
              )
            )
          )
        ),
        tabPanel(
          title = "Transformación de BD",
          fluidRow(
            valueBox(
              width = 4,
              value = 0, 
              subtitle = "Linea base: 0 bases",
              color = "light-blue",
              icon = icon("bullseye")
            ),
            valueBoxOutput(
              "valueBoxBasesIntermedia"
            ),
            valueBoxOutput(
              "valueBoxBasesFinal"
            )
          ),
          fluidRow(
            box(
              width = 8,
              title = "Fases de transformación de las bases de datos",
              DT::dataTableOutput(
                outputId = "tablaBases"
              )
            )
          )
        ),
        tabPanel(
          title = "Protocolo",
          fluidRow(
            valueBox(
              width = 4,
              value = 0, 
              subtitle = "Linea base",
              color = "light-blue",
              icon = icon("bullseye")
            ),
            valueBoxOutput(
              "valueBoxProtocoloIntermedia"
            ),
            valueBoxOutput(
              "valueBoxProtocoloFinal"
            )            
          ),
          fluidRow(
            box(
              width = 8,
              title = "Estado de avance en el desarrollo del Protocolo del SIAgro",
              DT::dataTableOutput(
                outputId = "tablaProtocolo"
              )
            )
          )
        ),
        tabPanel(
          title = "Investigación",
          fluidRow(
            valueBox(
              width = 4,
              value = 2, 
              subtitle = "Línea base",
              color = "light-blue",
              icon = icon("bullseye")
            ),
            valueBoxOutput(
              "valueBoxInvestigacionesIntermedia"
            ),
            valueBoxOutput(
              "valueBoxInvestigacionesFinal"
            )
          )
        ),
        tabPanel(
          title = "Áreas de intervención",
          fluidRow(
            valueBox(
              width = 4,
              value = "2 áreas", 
              subtitle = "Línea base",
              color = "light-blue",
              icon = icon("bullseye")
            ),
            valueBoxOutput(
              "valueBoxAreasIntermedia"
            ),
            valueBoxOutput(
              "valueBoxAreasFinal"
            )
          )
        ),
        tabPanel(
          title = "Publicaciones",
          fluidRow(
            valueBox(
              width = 4,
              value = 0,
              color = "light-blue",
              subtitle = "Línea base", 
              icon = icon("bullseye")
            ),
            valueBoxOutput(
              "valueBoxPublicacionesIntermedia"
            ),
            valueBoxOutput(
              "valueBoxPublicacionesFinal"
            )
          ),
          fluidRow(
            box(
              width = 8,
              title = "Número de publicaciones derivadas de los proyectos de investigación",
              plotlyOutput(
                outputId = "publicaciones",
                inline = TRUE)
            )
          )  
        )
      ) # /tabBox
    ),
    tabItem(
      tabName = "comunicacion",
      "COMUNICACION"),
    tabItem(
      tabName = "politicas",
      tabBox(
        width = 12,
        tabPanel(
          "Indicador 1",
          fluidRow(
            valueBox(
              width = 8,
              value = 100, 
              subtitle = "Maximum total radiated energy (Joules)", 
              icon = icon("lightbulb-o")
              )
            )
          ),
        tabPanel("Indicador 2"))
    ),
    tabItem(
      tabName = "capacidades"),
    tabItem(
      tabName = "mercado")
  )
)

dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body,
                    skin = "green"
                    )


