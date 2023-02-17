#' Run App
#'
#' @returns a shiny app
#' @import shiny
#' @export
#'
#' @examples
#' n -> 1+2
run_app <- function(){
  shinyApp(ui = app_ui, server = app_server)}
