# The user-interface definition of the Shiny web app.
library(shiny)
library(BH)
library(rCharts)
require(markdown)
require(data.table)
library(dplyr)
library(DT)

shinyUI(
  navbarPage("LEGO Set Lookup Tool", 
  # Multi-page UI that includes a navigation bar.
    tabPanel("View The Data",
      sidebarPanel(
        sliderInput("YearRange", 
                      "Year Range:", 
                    min = 1950,
                    max = 2016,
                    value = c(1980, 2016)),
        sliderInput("pieces", 
                    "Number of Pieces:",
                    min = -1,
                    max = 5922,
                    value = c(500, 1500)),
        uiOutput("themesControl"), # the id
        actionButton(inputId = "DeselectAll", 
                     label = "Deselect All", 
                     icon = icon("square-o")),
        actionButton(inputId = "selectAll", 
                     label = "Select all", 
                     icon = icon("check-square-o"))
                        
      ),
                      mainPanel(
                        tabsetPanel(
                          # Data 
                          tabPanel(p(icon("table"), "LEGO Sets"),
                                   dataTableOutput(outputId="dTable")
                          ),
                          tabPanel(p(icon("line-chart"), "Graph The Data"),
                                   h4('Number of Sets by Year', align = "center"),
                                   h5('Please hover over point on the line to see the Year and Total Number of Sets.', 
                                      align ="center"),
                                   showOutput("setsByYear", "nvd3"),
                                   h4('Number of Themes by Year', align = "center"),
                                   h5('Please hover over each bar to see the Year and Total Number of Themes.', 
                                      align ="center"),
                                   showOutput("themesByYear", "nvd3"),
                                   h4('Number of Pieces by Year', align = "center"),
                                   h5('Please hover over each point to see the Set Name, ID and Theme.', 
                                      align ="center"),
                                   showOutput("piecesByYear", "nvd3"),
                                   h4('Number of Average Pieces by Year', align = "center"),
                                   showOutput("piecesByYearAvg", "nvd3"),
                                   h4('Number of Average Pieces by Theme', align = "center"),
                                   showOutput("piecesByThemeAvg", "nvd3")
                          )
                          
                        )
                        
                      )     
             ),
             
             tabPanel(p(icon("search"), "Look Up Set on Brickset Database"),
                      mainPanel(
                        h3("Look up a LEGO set on Brickset.com."),
                        h4("Step 1. Please type the Set ID below and press the 'Create Address' button:"),
                        textInput(inputId="setid", label = "Enter Set ID"),
                        #p('Output Set ID:'),
                        #textOutput('setid'),
                        actionButton("goButtonAdd", "Create Address"),
                        h5('Address:'),
                        textOutput("address"),
                        p(""),
                        h4("Step 2. Please click the button below to generate the link to the Set's page."),
                        p(""),
                        actionButton("goButtonDirect", "Generate Link"),
                        p(""),
                        htmlOutput("inc"),
                        p("")
                        )         
                      ),
             
             tabPanel("About",
                      mainPanel(
                        includeMarkdown("About.md")
                      )
             )# end of "About" tab panel
       )  
  )