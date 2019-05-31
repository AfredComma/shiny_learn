library(shiny)
library(datasets)

# We tweak the "am" field to have nicer factor labels. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application
mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$mpgPlot expressions
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  sliderValues<- reactive({
    data.frame(
      Name=c("Integer",
             "Decimal",
             "Range",
             "Custom Format"),
      Value = as.character(c(input$integer,
                             input$decimal,
                             paste(input$range,collapse = ' '),
                             input$format)
                           
        
      ),
      stringsAsFactors = FALSE
    )
  }
    
  )
  
  data<- reactive({
    dist<-switch (input$dist,
                  norm = rnorm,
                  unif = runif,
                  lnorm= rlnorm,
                  exp = rexp,
                  rnorm)
    dist(input$n)
  })
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable against mpg and only 
  # include outliers if requested
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(formulaText()), 
            data = mpgData,
            outline = input$outliers)
  })
  output$values<-renderTable({
    sliderValues()
  })
  output$plot <- renderPlot({
    dist <- input$dist
    n<-input$n
    hist(data(),
         main = paste('r',dist,'(',n,')',sep = ''))
  })
  output$summary<- renderPrint({
    summary(data())
  })
  output$table <- renderTable({
    data.frame(x=data())
  })
  
  
})