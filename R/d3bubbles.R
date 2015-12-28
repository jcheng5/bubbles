
#' @export
d3bubbles <- function(data, valueCol = NULL, labelCol = NULL,
                      tooltipCol = NULL, colorCol = NULL, 
                      opts = NULL,
                      width = NULL, height = NULL) {
  
  labelCol <- labelCol %||% names(data)[1]
  valueCol <- valueCol %||% names(data)[2]
  colorCol <- colorCol %||% valueCol
  
  defaultOpts <-  list(
    padding = 3,
    textSplitWidth = 80,
    palette = "Purples",
    fixedColor = "#B7D1DF",
    textColor = "#444444",
    minSizeFactor = NA,
    maxSizeFactor = NA
  )
  
  settings <- mergeOptions(opts,defaultOpts)
  
  textColor <- settings$textColor

  if(is.null(opts$fixedColor)){
    v <- data[,colorCol]
    color <- NULL
    if(class(v) %in% c("factor","character"))
      color <- catColor(v,palette = settings$palette)
    if(class(v) %in% c("numeric","integer"))
      color <- numColor(v,palette = settings$palette)
  }else{
    color <- settings$fixedColor
  }
  
  
  d = data.frame(
    value = data[,valueCol],
    label = data[,labelCol],
    tooltip = data[,tooltipCol] %||% data[,labelCol],
    color = color,
    textColor = textColor
  )

  
  x <- list(
    d = d,
    settings = settings
  )
  
  str(x)
  
  # create widget
  htmlwidgets::createWidget(
    name = 'd3bubbles',
    x,
    width = width,
    height = height,
    package = 'd3bubbles',
    sizingPolicy = sizingPolicy(
      defaultWidth = "100%",
      defaultHeight = 500
    )
  )
}

#' @export
d3bubblesOutput <- function(outputId, width = '100%', height = '500px'){
  shinyWidgetOutput(outputId, 'd3bubbles', width, height, package = 'd3bubbles')
}

#' @export
renderD3bubbles <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, d3bubblesOutput, env, quoted = TRUE)
}
