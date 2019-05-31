library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Miles Per Gallon"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
    selectInput("variable", "Variable:",
                list("Cylinders" = "cyl", 
                     "Transmission" = "am", 
                     "Gears" = "gear")),
    
    checkboxInput("outliers", "Show outliers", FALSE),
    sliderInput("integer", "Comma:",
                min = 0, max = 1000, value = 500),
    sliderInput("decimal", "Decimal:",
                min = 0, max = 1,value = 0.5,step = 0.1),
    sliderInput("range","Range:",
                min = 1,max = 1000,value=c(200,500)),
    sliderInput("format","Custo Format:",
                min = 0,max = 10000,value = 0,step = 2500,
                format="$#,##0", locale="us",animate = TRUE),
    
    radioButtons("dist","Distribution type:",
                 list("Normal"="norm",
                      "uniform"="unif",
                      "Log-normal"="lnorm",
                      "Exponential"="exp")),
    br(),
    sliderInput("n",
                "Number of observations:",
                value = 500,
                min = 1,
                max = 1000
      
    )
  ),
  
  # Show the caption and plot of the requested variable against mpg
  mainPanel(
    h3(textOutput("caption")),
    
    plotOutput("mpgPlot"),
    tableOutput("values"),
    tabsetPanel(
      tabPanel("plot",plotOutput("plot")),
      tabPanel("Summary", verbatimTextOutput("summary")),
      tabPanel("Table",tableOutput("table"))
    )
    
  )
))