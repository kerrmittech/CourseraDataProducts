library(shiny)

# Load helper file to process data
source("data_processing.r")
themes <- sort(unique(data$theme))

# Shiny server
shinyServer(
  function(input, output) {
    output$setid <- renderText({input$setid})
    
    output$address <- renderText({
      input$goButtonAdd
      isolate(paste("http://brickset.com/sets/", 
                    input$setid, sep=""))
      
    })
    
    openPage <- function(url) {
      return(tags$a(href=url, "Click here!", target="_blank"))
    }
    
    output$inc <- renderUI({ 
      input$goButtonDirect
      isolate(openPage(paste("http://brickset.com/sets/", 
                             input$setid, sep="")))
    })
    
    
    # Initialize reactive values
    values <- reactiveValues()
    values$themes <- themes
    
    # Create event type checkbox
    output$themesControl <- renderUI({
      checkboxGroupInput('themes', 'LEGO Themes:', 
                         themes, selected = values$themes)
    })
    
    # Add observer on select-all button
    observe({
      if(input$selectAll == 0) return()
      values$themes <- themes
    })
    
    # Add observer on clear-all button
    observe({
      if(input$DeselectAll == 0) return()
      values$themes <- c()
    })
    
    # Prepare dataset
    dataTable <- reactive({
      groupByTheme(data, input$YearRange[1], 
                   input$YearRange[2], input$pieces[1],
                   input$pieces[2], input$themes)
    })
    
    dataTableBySetYear <- reactive({
      groupByYearSet(data, input$YearRange[1], 
                     input$YearRange[2], input$pieces[1],
                     input$pieces[2], input$themes)
    })
    
    dataTableByYear <- reactive({
      groupByYearAgg(data, input$YearRange[1], 
                     input$YearRange[2], input$pieces[1],
                     input$pieces[2], input$themes)
    })
    
    dataTableByPiece <- reactive({
      groupByYearAll(data, input$YearRange[1], 
                     input$YearRange[2], input$pieces[1],
                     input$pieces[2], input$themes)
    })
    
    dataTableByPieceAvg <- reactive({
      groupByPieceAvg(data, input$YearRange[1], 
                      input$YearRange[2], input$pieces[1],
                      input$pieces[2], input$themes)
    })
    
    dataTableByPieceThemeAvg <- reactive({
      groupByPieceThemeAvg(data, input$YearRange[1], 
                           input$YearRange[2], input$pieces[1],
                           input$pieces[2], input$themes)
    })
    
    # Render data table
    output$dTable <- renderDataTable({
      dataTable()
    } 
    )
    
    output$setsByYear <- renderChart({
      plotSetsCountByYear(dataTableBySetYear())
    })
    
    output$themesByYear <- renderChart({
      plotThemesCountByYear(dataTableByYear())
    })
    
    output$piecesByYear <- renderChart({
      plotPiecesByYear(dataTableByPiece())
    })
    
    output$piecesByYearAvg <- renderChart({
      plotPiecesByYearAvg(dataTableByPieceAvg())
    })
    
    output$piecesByThemeAvg <- renderChart({
      plotPiecesByThemeAvg(dataTableByPieceThemeAvg())
    })
    
  } # end of function(input, output)
)