library(ggplot2)


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Life Expectancy vs GDP per Capita"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "years",
                  label = "Year",
                  min = 1952,
                  max = 2007,
                  step = 5,
                  value = 2007)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput(outputId = "plot")
    )
  ),
  mainPanel(
    plotOutput(outputId = "plot2")
  ),
  mainPanel(
    plotOutput(outputId = "plot3")
  ),
  mainPanel(
    plotOutput(outputId = "plot4")
  ),
  mainPanel(
    plotOutput(outputId = "plot5")
  ),
  mainPanel(
    plotOutput(outputId = "plot6")
  )
)