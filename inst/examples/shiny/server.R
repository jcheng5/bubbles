library(bubbles)
library(dplyr)
library(shinySignals)

function(input, output, session) {
  
  # Connect to data source
  pkgData <- connectToLogs(session)

  output$bubbles <- renderBubbles({
    if (is.null(pkgData()))
      return(NULL)
    
    df <- pkgData() %>%
      select_(label = input$by) %>%
      group_by(label) %>%
      tally() %>%
      arrange(match(label, pkgData()[[input$by]]))
    
    value <- switch(input$scale,
      area = sqrt(df$n),
      radius = df$n
    )
    
    bubbles(value = value, label = df$label,
      tooltip = sprintf("%s: %d", df$label, df$n)
    )
  })
}
