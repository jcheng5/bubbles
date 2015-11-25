
#' @export
d3bubbles <- function(data, valueCol = NULL, labelCol = NULL,
                      colorCol = NULL,
                      opts = NULL,
                      tooltipCol = NULL, color = "#B7D1DF",
                      textColor = "#99999", 
                      width = NULL, height = NULL) {
  
  labelCol <- labelCol %||% names(data)[1]
  valueCol <- valueCol %||% names(data)[2]
  
  if(!is.null(colorCol)){
    v <- data[,colorCol]
    if(class(v) %in% c("factor","string"))
      color <- catColor(v,palette = opts$palette)
    if(class(v) %in% c("numeric","integer"))
      color <- numColor(v,palette = opts$palette)
  }
  
  d = data.frame(
    value = data[,valueCol],
    label = data[,labelCol],
    tooltip = data[,tooltipCol] %||% data[,labelCol],
    color = color,
    textColor = textColor
  )
  if (!is.null(key)) {
    d <- cbind(d, data.frame(key = key))
  }
  
  defaultOpts <-  list(
    padding = 3,
    textSplitWidth = 80,
    palette = "Set1"
  )
  
  settings <- mergeOptions(opts,defaultOpts)
  
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
d3bubblesOutput <- function(outputId, width = '600px', height = '600px'){
  shinyWidgetOutput(outputId, 'd3bubbles', width, height, package = 'd3bubbles')
}

#' @export
renderD3bubbles <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, d3bubblesOutput, env, quoted = TRUE)
}
