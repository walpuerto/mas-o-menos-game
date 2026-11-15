library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Más o menos!"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("length",
                        "Hasta número...",
                        min = 0,
                        max = 100,
                        value = 50),
            actionButton("restart",
                         "Comenzar!"),
            hr(),
            uiOutput("guess_input"), 
        ),

        # Show a plot of the generated distribution
        mainPanel(
            imageOutput("response")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  actual_responsive <- reactive({sample(0:input$length, 1)}) |> 
    bindEvent(input$restart)
  
  output$guess_input <- renderUI({
    numericInput(
      "guess", 
      "Divinar un número...", 
      value = 1, 
      min = 0, 
      max = input$length
    )
  })
  
  output$response <- renderImage( 
    { 
      actual <- actual_responsive()
      
      if (input$guess == actual) {
        list(src = "exacto.png", height = "25%") 
      } else if (input$guess < actual) {
        list(src = "mas.png", height = "25%") 
      } else if (input$guess > actual) {
        list(src = "menos.png", height = "25%") 
      }
    }, 
    deleteFile = FALSE 
  ) 
}

# Run the application 
shinyApp(ui = ui, server = server)
