library(bubbles)

fluidPage(
  h1("Live* CRAN downloads"),
  p("* 10080 minute delay"),
  sidebarLayout(
    sidebarPanel(
      selectInput("by", "Summarize by", c(
        "Package" = "package",
        "Country" = "country",
        "Client IP" = "ip_id",
        "R version" = "r_version",
        "Operating system" = "r_os"
      ), selected = "package"),
      radioButtons("scale", "Proportional to",
        c("radius", "area"), selected = "radius"
      )    
    ),
    mainPanel(
      bubblesOutput("bubbles", width = "100%", height = 500)
    )
  )
)

