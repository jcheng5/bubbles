#' Bubble Chart
#' 
#' Creates a bubble chart.
#' 
#' @param value Numeric vector of values, used for sizing bubbles
#' @param label Character vector of textual labels to use on bubbles
#' @param tooltip Character vector of tooltip values, to be shown on hover
#' @param color Character vector of color values, in \code{"#RRGGBB"} format
#' @param width The width of the widget, or \code{NULL} for default.
#' @param height The height of the widget, or \code{NULL} for default.
#'   
#' @return A widget object that can be printed at the console, outputted as part
#'   of an R Markdown document, or used in a Shiny app with
#'   \code{\link{renderBubbles}}.
#'   
#' @import htmlwidgets
#'   
#' @export
bubbles <- function(value, label, tooltip = "", color = "#EEEEEE",
  width = NULL, height = NULL) {

  # forward options using x
  x = data.frame(
    value = value,
    label = label,
    tooltip = tooltip,
    color = color
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'bubbles',
    x,
    width = width,
    height = height,
    package = 'bubbles',
    sizingPolicy = sizingPolicy(
      defaultWidth = 600,
      defaultHeight = 600
    )
  )
}

#' Bubble chart functions for Shiny
#' 
#' @param outputId Shiny output ID for this bubble chart
#' @param width,height Plot width/height. Must be a valid CSS unit (e.g. "100%",
#'   "400px") or a number, which will be interpreted as pixels ("px").
#' @param expr An expression that generates a \code{\link{bubbles}} widget.
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})?
#'   
#' @export
bubblesOutput <- function(outputId, width = '100%', height = '600px'){
  shinyWidgetOutput(outputId, 'bubbles', width, height, package = 'bubbles')
}

#' @rdname bubblesOutput
renderBubbles <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, bubblesOutput, env, quoted = TRUE)
}
