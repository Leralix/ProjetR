
# Define server logic required to draw a histogram
server <- function(input, output) {
  output$plot <- renderPlot({
    
    gapminder %>%
      filter(year==input$years) %>%
      ggplot(aes(x=gdpPercap, y=lifeExp,group=continent,color=continent)) +
      geom_point(aes(size=pop))
  })
}