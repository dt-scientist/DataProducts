library(shiny)
library(ggplot2)
library(shinyapps)

# shinyUI(fluidPage(
#   
#   title = "Time series - Exploratory data analysis",
shinyUI(navbarPage("Time series - Exploratory data analysis",
                   tabPanel("Plot",    
  plotOutput("myChart"),
  fluidRow(
    column(4,
           textInput("symb", "Symbol", "BARC.L"),
           dateRangeInput("dates", 
                          "Date range",
                          start = "2013-01-01", 
                          end = as.character(Sys.Date())),
           radioButtons("periodicity", label ="Periodicity", 
                        choices = c("daily" = "days", "weekly" = "weeks"),
                        selected = "days")
    ),
    column(4,
           selectInput("transforms", "Transformations",
                       c("none" = "none",
                         "square" = "sq",
                         "square root" = "sqr",
                         "natural logarithm" = "nlog",
                         "common logarithm" = "clog",
                         "reciprocal" = "rec",
                         "reciprocal square root" = "recsqr"
                       )),
      
           selectInput("smooths", "Smooths",
                       c("ls" = "ls",
                         "lwr" = "lwr",
                         "poly2" = "poly2",
                         "poly5" = "poly5",
                         "gam" = "gam"
                       ), multiple = TRUE, selectize = TRUE)
    ),
    column(4,
            inputPanel(checkboxInput('linearfilter', 'Linear filter'),
            numericInput('lfperiod', 'Filter period:',20,min=2,max=50))
           #actionButton("showfile", "Help"),
           #textOutput("text1")
    )
 
  )),#end of tabpanel
  tabPanel("Help",includeMarkdown("help.md"))    
  
  ))