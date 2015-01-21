library(shiny)
library(shinySignals)

# Connects to streaming log data for cran.rstudio.com and
# returns a reactive expression that serves up the cumulative
# results as a data frame
connectToLogs <- function(session) {
  # Connect to data source
  sock <- socketConnection("rstudio.com", 6789, blocking = FALSE, open = "r")
  # Clean up when session is over
  session$onSessionEnded(function() {
    close(sock)
  })

  # Returns new lines
  newLines <- reactive({
    invalidateLater(1000, session)
    readLines(sock)
  })

  # An empty prototype of the data frame we want to create
  prototype <- data.frame(date = character(), time = character(),
    size = numeric(), r_version = character(), r_arch = character(),
    r_os = character(), package = character(), version = character(),
    country = character(), ip_id = character())

  # Parses newLines() into data frame
  newData <- reactive({
    if (length(newLines()) == 0)
      return()
    read.csv(textConnection(newLines()), header=FALSE, stringsAsFactors=FALSE,
      col.names = names(prototype)
    )
  })

  # Accumulates newData results over time
  pkgData <- shinySignals::reducePast(newData, rbind, prototype)

  pkgData
}

