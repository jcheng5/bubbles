#' Bubble Chart
#' 
#' Creates a bubble chart.
#' 
#' @param value Numeric vector of values, used for sizing bubbles. The value 
#'   will be proportional to the radius, not the area; for area, call 
#'   \code{\link{sqrt}} on the value.
#' @param label Character vector of textual labels to use on bubbles
#' @param key Values that will uniquely identify a bubble across runs. This
#'   doesn't matter for static bubble charts, but if a bubble chart receives
#'   updates (i.e. in a Shiny app) then d3.js will use the key to know which
#'   bubbles in the "before" state correspond with which bubbles in the
#'   "after" state, and perform smooth transitions. If \code{NULL}, then the
#'   key will effectively be the row number.
#' @param tooltip Character vector of tooltip values, to be shown on hover
#' @param color Character vector of bubble color values, in \code{"#RRGGBB"}
#'   format; can be length 1 or length of \code{value}
#' @param textColor Character vector of text color values, in \code{"#RRGGBB"}
#'   format; can be length 1 or length of \code{value}
#' @param width The width of the widget, or \code{NULL} for default.
#' @param height The height of the widget, or \code{NULL} for default.
#'   
#' @return A widget object that can be printed at the console, outputted as part
#'   of an R Markdown document, or used in a Shiny app with 
#'   \code{\link{renderBubbles}}.
#'   
#' @examples
#' bubbles(runif(10), LETTERS[1:10], color = rainbow(10, alpha = NULL))
#'   
#' @import htmlwidgets
#'   
#' @export
bubbles <- function(value, label, key = NULL, tooltip = "", color = "#EEEEEE",
  textColor = "#333333", width = NULL, height = NULL, group = NULL) {

  # forward options using x
  x = data.frame(
    value = value,
    label = label,
    tooltip = tooltip,
    color = color,
    textColor = textColor
  )
  if (!is.null(key)) {
    x <- cbind(x, data.frame(key = key))
  }

  # create widget
  htmlwidgets::createWidget(
    name = 'bubbles',
    list(data = x, group = group),
    width = width,
    height = height,
    package = 'bubbles',
    sizingPolicy = sizingPolicy(
      defaultWidth = 600,
      defaultHeight = 600
    ),
    dependencies = list(crosstalk::dependency)
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
bubblesOutput <- function(outputId, width = '600px', height = '600px'){
  shinyWidgetOutput(outputId, 'bubbles', width, height, package = 'bubbles')
}

#' @rdname bubblesOutput
#' @export
renderBubbles <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, bubblesOutput, env, quoted = TRUE)
}
