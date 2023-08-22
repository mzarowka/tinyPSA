library(shiny)
library(shinyFiles)
library(bslib)
library(fs)
library(DT)

ui <- bslib::page_sidebar(
  theme = bs_theme(bootswatch = "zephyr"),
  title = "PSA helpers",
  sidebar = bslib::sidebar(
    shinyDirButton("directory", "Folder select", "Please select a directory containing your CSV files", icon = shiny::icon("folder")),

    shinyFilesButton("file", "File select", "Please select a GRADISTAT XLSM file", multiple = FALSE, icon = shiny::icon("file"))
    ),
    bslib::card(
      textOutput("dirPath"),

      textOutput("filePath")
    ),
  card(DT::dataTableOutput("dataCsv", height = "30%" ))
  )

server <- function(input, output, session) {
  volumes <- c(getVolumes()())
  shinyFileChoose(input, "file", roots = volumes, session = session)
  # by setting `allowDirCreate = FALSE` a user will not be able to create a new directory
  shinyDirChoose(input, "directory", roots = volumes, session = session, restrictions = system.file(package = "base"), allowDirCreate = FALSE)

  output$dirPath <- renderPrint({
    if (is.integer(input$directory)) {
      cat("No directory has been selected yet.")
    } else {
      parseDirPath(volumes, input$directory)
    }
  })

  output$filePath <- renderPrint({
    if (is.integer(input$file)) {
      cat("No file has been selected yet.")
    } else {
      parseFilePaths(volumes, input$file)
    }
  })

  dirpath <- reactive({
    parseDirPath(volumes, input$directory)
  })

  data_csv <- reactive({
    tinyPSA::tpsa_read(dirpath(), mode = "directory")
  })

  output$dataCsv <- renderDataTable(data_csv())
}

shinyApp(ui, server, options = list(launch.browser = TRUE))
