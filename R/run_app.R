#' Run App
#'
#' @returns a shiny app
#' @import shiny
#' @export
#'
#' @examples
#' # run_app()
#' # see vignette
#'
run_app <- function(){
  shinyApp(ui = app_ui, server = app_server)}
