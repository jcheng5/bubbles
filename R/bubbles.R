#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
bubbles <- function(message, width = NULL, height = NULL) {

  # forward options using x
  x = list(
    message = message
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'bubbles',
    x,
    width = width,
    height = height,
    package = 'bubbles'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
bubblesOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'bubbles', width, height, package = 'bubbles')
}

#' Widget render function for use in Shiny
#'
#' @export
renderBubbles <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, bubblesOutput, env, quoted = TRUE)
}
