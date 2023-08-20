library(shiny)
library(bslib)

ui <- bslib::page_sidebar(
  theme = bslib::bs_theme(bootswatch = "zephyr"),
  title = "BSi calculators",
  sidebar = sidebar(max_height = "33%",
                    numericInput("samples", label = "Samples to process", value = 40),

                    radioButtons("standards", "Do you need to add standard and blank samples?", choices = list(Yes = "yes", No = "no")),

                    textOutput("sampleBack")),
  card(

  card(
    max_height = "33%",
    textOutput("metolTotal"),
    textOutput("metolWorking"),
    textOutput("oxalicWorking"),
    textOutput("sulfuricWorking")
  ),
  card(
    max_height = "33%",
    textOutput("molybdateTotal"),
    textOutput("waterWorking"),
    textOutput("molybdateWorking"),
    textOutput("hydrochloricWorking")
  )
)
)
server <- function(input, output, session) {

  samples <- reactive({
    if (input$standards == "yes") {
      input$samples + 2 + 6
    } else {
      input$samples + 2
    }
  })

  output$sampleBack <- renderText({
    paste("Will calculate for", samples(), " samples.")
  })

  output$metolTotal <- renderText({
      paste("Total metol working solution is ", round(samples() * 9.00), " mL. Use: ")
  })

  output$metolWorking <- renderText({
    paste("Working metol solution: ", round(samples() * 9.00 / 3.00), " mL.")
  })

  output$oxalicWorking <- renderText({
    paste("Oxalic acid: ", round(samples() * 9.00 / 3.00), " mL.")
  })

  output$sulfuricWorking <- renderText({
    paste("Sulfuric acid: ", round(samples() * 9.00 / 3.00), " mL.")
  })

  output$molybdateTotal <- renderText({
    paste("Total molybdate working solution is ", round(samples() * 20.00), " mL. Use:")
  })

  output$molybdateWorking <- renderText({
    paste("Working molybdate solution: ", round(samples() * 20.00 / 7.00), " mL.")
  })

  output$hydrochloricWorking <- renderText({
    paste("Hydrochloric acid: ", round(samples() * 20.00 / 7.00), " mL.")
  })

  output$waterWorking <- renderText({
    paste("Reagent grade water: ", round(samples() * 20.00 / 7.00 * 5.00), " mL.")
  })
}

shinyApp(ui, server)
