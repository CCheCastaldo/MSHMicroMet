#' R shiny app for visualizing daat contained within MSHMIcroMet package
#'
#' R shiny app for visualizing the location and metadata for HOBO deployments on Mount St. Helens and time series of temperature and relative humidity measurements collected during each deployment
#'
#' @examples
#' # microMetViz()
#'
#' @importFrom magrittr %>%
#' @export
#'

microMetViz <- function() {

  colorBox <- function(color, text = ""){
  htmltools::div(htmltools::tags$span(text, style = "padding-left: 30px;"),
      htmltools::div(style = paste0("background-color:", color, "; ","display:inline-block;position:absolute;height:13px;width:13px;left: 5px;top:3px;")),
      style = "position: relative;"
  )}

#----------------------------------------------------------------------------------------------------------------
ui <- shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(title = "MSHMicroMet"),
    shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(
        shinydashboard::menuItem("Deployment Map", tabName = "deployment_map", icon = shiny::icon("map")),
        shinydashboard::menuItem("Deployment Table", tabName = "header_table", icon = shiny::icon("table")),
        shinydashboard::menuItem("Time Series Plots", tabName = "time_series_plots", icon = shiny::icon("chart-line")),
        shiny::sliderInput("years_deployed", "Years Deployed", min = 1997, max = 2022, value = c(1997, 2022), step = 1, sep = ""),
        shiny::checkboxInput("terrestrial", "Terrestrial HOBO deployments", value = TRUE),
        shiny::checkboxInput("aquatic", "Aquatic HOBO deployments", value = TRUE)
      )),
  shinydashboard::dashboardBody(
    shinydashboard::tabItems(
      shinydashboard::tabItem(tabName = "deployment_map",
              shiny::fluidPage(shiny::fluidRow(leaflet::leafletOutput("themap", height = 1000)))),
      shinydashboard::tabItem(tabName = "header_table",
                              shiny::fluidPage(shiny::fluidRow(DT::dataTableOutput("thetable"))),
                              shiny::fluidRow(
                                shiny::column(2, colorBox('#A1DBE2', "Aquatic deployment")),
                                shiny::column(2, colorBox('#FCA543', "Terrestrial deployment")),
                                shiny::column(2, colorBox('#FB5446', "HOBO data lost")),
                                shiny::column(2, colorBox('#E2EF07', "HOBO currently in situ")),
                                shiny::column(2, colorBox('#D4EFED', "HOBO data has been checked/clipped")),
                                shiny::column(2, colorBox('#E2A1DC', "HOBO data collected but not checked"))),


                              ),
      shinydashboard::tabItem(tabName = "time_series_plots",
                              shiny::fluidPage(
                                shiny::fluidRow(dygraphs::dygraphOutput("dygraph_temp")),
                                shiny::fluidRow(dygraphs::dygraphOutput("dygraph_RH"))))
    )
  )
)

#----------------------------------------------------------------------------------------------------------------
server <- function(input, output) {

  rv <- shiny::reactiveValues()

  shiny::observeEvent(list(input$years_deployed, input$terrestrial, input$aquatic), {
    if (input$terrestrial == TRUE & input$aquatic == FALSE) {
      rv$df <- MSHMicrometHeader[c(MSHMicrometHeader$year_deployed >= input$years_deployed[1] &
                                   MSHMicrometHeader$year_deployed <= input$years_deployed[2] &
                                   MSHMicrometHeader$terrestrial == TRUE), ]
    }
    if (input$terrestrial == FALSE & input$aquatic == TRUE) {
      rv$df <- MSHMicrometHeader[c(MSHMicrometHeader$year_deployed >= input$years_deployed[1] &
                                   MSHMicrometHeader$year_deployed <= input$years_deployed[2] &
                                   MSHMicrometHeader$terrestrial == FALSE), ]
    }
    if ((input$terrestrial == TRUE & input$aquatic == TRUE) | (input$terrestrial == FALSE & input$aquatic == FALSE)) {
      rv$df <- MSHMicrometHeader[c(MSHMicrometHeader$year_deployed >= input$years_deployed[1] &
                                   MSHMicrometHeader$year_deployed <= input$years_deployed[2]), ]
    }
  })

  output$themap <- leaflet::renderLeaflet({
    df <- rv$df
    df$icon <- "terrestrial"
    df$icon[which(df$terrestrial == FALSE)] <- "aquatic"
    logos <- leaflet::awesomeIconList(
      "terrestrial" = leaflet::makeAwesomeIcon(
        markerColor = "orange",
        library = "fa"),
      "aquatic" = leaflet::makeAwesomeIcon(
        markerColor = "blue",
        library = "fa"))
    leaflet::leaflet(data = df) %>%
      leaflet::addProviderTiles(leaflet::providers$OpenTopoMap,
                                options = leaflet::providerTileOptions(noWrap = TRUE)) %>%
      leaflet::addAwesomeMarkers(~decimal_longitude,
                                 ~decimal_latitude,
                                 icon = ~logos[icon],
                                 popup = ~as.character(site_description),
                                 label = ~as.character(site_id))
  })

  output$thetable <- DT::renderDataTable({
    df <- rv$df[, c("survey_id", "site_id", "site_description", "zone", "serial", "sensor_part", "height", "interval",
                    "deployment_datetime", "retrieval_datetime", "terrestrial", "status", "year_deployed")]
    DT::datatable(df,
                  rownames = F,
                  selection = list(mode = 'single', selected = 1),
                  options = list(pageLength = 25, columnDefs = list(list(visible = FALSE, targets = c(10, 11, 12))))) %>%
      DT::formatDate(9:10, c('toLocaleString', 'toLocaleString')) %>%
      DT::formatStyle('site_id', 'terrestrial', backgroundColor = DT::styleEqual(c(0, 1), c('#A1DBE2', '#FCA543'))) %>%
      DT::formatStyle('retrieval_datetime',
                      'status',
                      backgroundColor = DT::styleEqual(c("lost", "raw", "clean", "active"), c('#FB5446', '#E2A1DC', '#D4EFED', '#E2EF07')))
  })

  output$dygraph_temp <- dygraphs::renderDygraph({
    dt_header <- rv$df[input$thetable_rows_selected, ]
    dt_header$series_name <- paste(dt_header$survey_id, dt_header$site_id, dt_header$year_deployed, sep = "_")
    shiny::req(!(dt_header$status %in% c("lost", "active")))
    dt_temp <- MSHMicrometData[MSHMicrometData$survey_id == dt_header$survey_id, c("temperature", "datetime")]
    out_temp <- xts::xts(dt_temp[, 1], order.by = dt_temp[, 2])
    dygraphs::dygraph(out_temp, main = paste0("Temperature: ", dt_header$series_name))  %>%
      dygraphs::dyRangeSelector(height = 20) %>%
      dygraphs::dyOptions(axisLineWidth = 1.5) %>%
      dygraphs::dyOptions(includeZero = TRUE, axisLineColor = "navy", gridLineColor = "lightblue") %>%
      dygraphs::dyRangeSelector()
  })

  output$dygraph_RH <- dygraphs::renderDygraph({
    dt_header <- rv$df[input$thetable_rows_selected, ]
    dt_header$series_name <- paste(dt_header$survey_id, dt_header$site_id, dt_header$year_deployed, sep = "_")
    shiny::req(!(dt_header$status %in% c("lost", "active")))
    dt_RH <- MSHMicrometData[MSHMicrometData$survey_id  == dt_header$survey_id, c("relative_humidity", "datetime")]
    out_RH <- xts::xts(dt_RH[, 1], order.by = dt_RH[, 2])
    dygraphs::dygraph(out_RH, main = paste0("Relative Humidity: ", dt_header$series_name)) %>%
      dygraphs::dyRangeSelector(height = 20) %>%
      dygraphs::dyOptions(axisLineWidth = 1.5) %>%
      dygraphs::dyOptions(includeZero = TRUE, axisLineColor = "navy", gridLineColor = "lightblue") %>%
      dygraphs::dyRangeSelector()
  })

}

shiny::shinyApp(ui, server)
}
