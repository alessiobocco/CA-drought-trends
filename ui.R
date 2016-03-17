
library(shiny)

shinyUI(
  fluidPage(
  # Application title
  titlePanel("Drought Awareness in California"),

  sidebarLayout(
    sidebarPanel(
      p("In the first plot explore the trends between drought severity in California and public interest in related topics."),
      p("The vertical line indicates when Gov Brown declared a State of Drought Emergency for the state of CA on January 17, 2014."),
      h3("Public Interest"),
      p("Select terms to chart the frequency of the following water-related Google search terms."),
    checkboxGroupInput("google_trend", 
                       label = h5("Select Google search term:"), selected = "drought",
                choices = list("water_conservation", "drought", "drought_in_california", "climate_change","xeriscaping","water_use","pool_party", "dog_days")
                
      ),
    h3("Drought index"),
    p("Select Drought Index to see the Palmer Drought Severity Index in California. Values below 27 are considered a drought, below 9 is extreme drought. Values above 73 are considered a water surplus."),
    checkboxInput("Palmer_Drought_INDEX", 
                       label = "Palmer Drought Severity Index"
    ),
    # Date input
    h3("Scale x-axis to zoom in on time:"),
    p("Scale the first graph to see how public drought awareness compares to water use. Valid starting dates are 2004-01-01 to 2016-01-01."),
    dateInput('date_input',
              label = 'Start date input: yyyy-mm-dd',
              value = "2004-01-01"
    )
    ),

    mainPanel(
        tabPanel("Drought Severity and Google Search Words",
                 plotOutput("google.plot", height="350",width="900"),
                 plotOutput("water_use.plot", height="300",width="900"))
    )
  )
)
)