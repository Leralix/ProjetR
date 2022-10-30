library(dplyr)
library(gapminder)


#Transfrom CSV as Table
df <- read.table("LaCentrale_60Pages.csv", header = TRUE, sep = ",", quote ='', dec = ".", fill = TRUE, comment.char = "")
da=df
da$Émissions_de_CO2=as.integer(gsub("[a-z]","",gsub("/","",gsub(" ","",da$Émissions_de_CO2))))

#pie_chart=da%>%group_by(Année)%>%count(Énergie) %>% filter(Année==2020) %>% ggplot(aes(x=Année,y=n,fill=Énergie))+
#  +      geom_bar(stat="identity",width=1)

#Create MAp
spdf <- geojson_read("ze2020_2022 - Copie.json",what="sp")
spdf_fortified <- tidy(spdf,region="code")
da_depart<- count(da,Localisation)
da_depart$Localisation=as.character(da_depart$Localisation)
spdf_fortified=spdf_fortified %>% left_join(.,da_depart,by=c("id"="Localisation"))

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
  
  output$plot4 <- renderPlot({
    da%>%group_by(Année)%>%count(Énergie) %>% filter(Année==2020) %>% ggplot(aes(x=Année,y=n,fill=Énergie))+      geom_bar(stat="identity",width=1,color="white")+ coord_polar("y",start=0)+theme_void()+ggtitle("Voiture datant de 2020")
    })
  
  output$plot5 <- renderPlot({
    da%>%group_by(marque)%>%count(CritAir) %>% ggplot(aes(x=marque,y=n,fill=factor(CritAir)))+geom_bar(stat="identity")+scale_fill_manual(values=c("#a5fc03","green","yellow","orange","red","black"))+theme(axis.text.x=element_text(angle=90))+ggtitle("Répartition CritAir par maque")
  })
  
  output$plot6 <- renderPlot({
    ggplot()+geom_polygon(data=spdf_fortified,aes(fill=n,x=long,y=lat,group=group))+theme_void()+coord_sf(xlim = c(-6,10),ylim=c(41,52))+scale_fill_viridis_b(option = "C")
    })
  
  
}