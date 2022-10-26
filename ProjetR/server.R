library(dplyr)


#Transfrom CSV as Table
df <- read.table("LaCentrale_60Pages.csv", header = TRUE, sep = ",", quote ='', dec = ".", fill = TRUE, comment.char = "")
da=df
da$Émissions_de_CO2=as.integer(gsub("[a-z]","",gsub("/","",gsub(" ","",da$Émissions_de_CO2))))

#pie_chart=da%>%group_by(Année)%>%count(Énergie) %>% filter(Année==2020) %>% ggplot(aes(x=Année,y=n,fill=Énergie))+
#  +      geom_bar(stat="identity",width=1)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$plot <- renderPlot({
    
    gapminder %>%
      filter(year==input$years) %>%
      ggplot(aes(x=gdpPercap, y=lifeExp,group=continent,color=continent)) +
      geom_point(aes(size=pop))
  })
  
  output$plot2 <- renderPlot({
      ggplot(da,aes(x=Émissions_de_CO2))+geom_histogram()
  })
  
  output$plot3 <- renderPlot({
    da%>%count(Année)%>% ggplot(aes(x=Année,y=n))+geom_line()  
    })
  
  
}