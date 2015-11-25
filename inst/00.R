

library(devtools)
load_all()
document()
install()

library(d3bubbles)


# BUBBLES
d <- read.csv("inst/data/soccer-teams-valuation.csv")
d3bubbles(d, labelCol = "Equipo",valueCol = "Valorización")

d3bubbles(d, labelCol = "Equipo",valueCol = "Valorización",
          opts = list(palette = "Pastel1"))

d3bubbles(d, labelCol = "Equipo",valueCol = "Valorización",
          opts = list(minSizeFactor = 10, maxSizeFactor = 20))
d3bubbles(d, labelCol = "Equipo",valueCol = "Valorización",
          opts = list(minSizeFactor = 10, maxSizeFactor = 33))

d3bubbles(d, labelCol = "Equipo", valueCol = "Valorización",  
          colorCol = "País")

d3bubbles(d, valueCol = "Valorización", labelCol = "Equipo", 
          colorCol = "País", tooltipCol = "País",
          opts = list(padding = 1, palette = "Pastel1", textSplitWidth = 50, textColor="#FF4343"))

d3bubbles(d, valueCol = "Valorización", labelCol = "Equipo",
          opts = list(padding = 50))

library(dpkgr)
t <- sampleData('CCN', asTabl = TRUE)
tabl <- t
data <- tabl$data
nms <- getCnames(tabl)
d3bubbles(data, labelCol = nms[1], colorCol = nms[2], valueCol = nms[3],
          opts = NULL)




