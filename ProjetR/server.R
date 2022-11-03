library(dplyr)
library(gapminder)
library(geojsonio)
library(broom)
library(treemapify)
library(tidyverse)

#Transfrom CSV as Table
df <- read.table("LaCentrale_60Pages.csv", header = TRUE, sep = ",", quote ='', dec = ".", fill = TRUE, comment.char = "")
da=df
da$Émissions_de_CO2=as.integer(gsub("[a-z]","",gsub("/","",gsub(" ","",da$Émissions_de_CO2))))
da$prix=as.integer(parse_number(gsub(" ","",gsub("€","",da$prix))))
da$Puissance_din=as.integer(parse_number(da$Puissance_din))
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

  output$Repartition_Emission <- renderPlot({
      ggplot(da,aes(x=Émissions_de_CO2))+geom_histogram()
  })
  
  output$NbVoiture_Per_Year <- renderPlot({
    da%>%count(Année)%>% ggplot(aes(x=Année,y=n))+geom_line()  
    })
  
  output$PieChart_Energie <- renderPlot({
   #da%>%group_by(Année)%>%count(Énergie) %>% filter(Année==2020) %>% ggplot(aes(x=Année,y=n,fill=Énergie))+      geom_bar(stat="identity",width=1,color="white")+ coord_polar("y",start=0)+theme_void()+ggtitle("Voiture datant de 2020")
    da%>%count(Énergie)%>% ggplot(aes(x="",y=n,fill=Énergie))+      geom_bar(stat="identity",width=1,color="white")+ coord_polar("y",start=0)+theme_void()+ggtitle("Type de consommation des véhicules vendus")
    })
  
  output$Histo_Energie <- renderPlot({
    da%>%count(Énergie)%>% ggplot(aes(x=n,y=Énergie,fill=Énergie))+      geom_bar(stat="identity",width=1,color="white")+geom_text(aes(label=n), color="black", size=3.5)+ggtitle("Type de consommation des véhicules vendus")
  })
  
  output$CritAir_Marque <- renderPlot({
    da%>%group_by(marque)%>%count(CritAir) %>% ggplot(aes(x=marque,y=n,fill=factor(CritAir)))+geom_bar(stat="identity")+scale_fill_manual(values=c("#a5fc03","green","yellow","orange","red","black"))+theme(axis.text.x=element_text(angle=90))+ggtitle("Répartition CritAir par maque")
  })
  
  output$Carte_NbVentes <- renderPlot({
    ggplot()+geom_polygon(data=spdf_fortified,aes(fill=n,x=long,y=lat,group=group))+theme_void()+coord_sf(xlim = c(-6,10),ylim=c(41,52))+scale_fill_viridis_b(option = "C")
    })
  
  output$NbVehicule_Marque <- renderPlot({
    da%>%count(marque)%>%ggplot(aes(area=n,fill=marque,label = paste(marque, n, sep = "\n")))+geom_treemap()+geom_treemap_text(colour = "white",place = "centre",size = 15) +theme(legend.position = "none")
  })
  
  output$Bubble_Emiss_Puiss_Prix <- renderPlot({
    da%>%group_by(Nombre_de_places)%>%ggplot(aes(x=prix,y=Puissance_din,size=sqrt(Émissions_de_CO2),color=Classe_Emission))+geom_point(alpha=0.5)+xlim(input$RangeBubbleGraph[1],input$RangeBubbleGraph[2])
  })
  
  
  plotType <- function(type) {
    switch(type,
           CritAir= da%>%ggplot(aes(x=Année,fill=as.factor(CritAir)))+geom_bar(),
           Contrôle_technique = da%>%ggplot(aes(x=Année,fill=as.factor(Contrôle_technique)))+geom_bar(),
           Classe_Emission=da%>%ggplot(aes(x=Année,fill=as.factor(Classe_Emission)))+geom_bar(),
           Norme_Euro=da%>%ggplot(aes(x=Année,fill=as.factor(Norme_Euro)))+geom_bar()
           )
  }
  
  output$Multiple_Histo <- renderPlot({
      plotType(input$choice)
    })
  
  output$table <- renderTable(head(da,5))

   

  co = da%>%count(Localisation)
  co$Localisation[co$n < max(co$n)/2]="Autre"

  output$Circular_Plot <- renderPlot({
    co%>%ggplot(aes(x="",y=n,fill=Localisation))+geom_bar(stat="identity")+coord_polar("y",start=0)+theme_void()
 
  })
  
  da2000 <- da[da$Année >= 2000, ]                                                                                                                                                                                                                                                                                                                                                             
  output$plot7 <- renderPlot({
    da2000%>%group_by(Année)%>%count(CritAir) %>% ggplot(aes(x=Année,y=n,fill=factor(CritAir)))+geom_bar(stat="identity", position="fill")+scale_fill_manual(values=c("#a5fc03","green","yellow","orange","red","black"))+theme(axis.text.x=element_text(angle=90))+ggtitle("Evolution du \" Crit' air\" des voitures construites entre 2000")
    #da%>%group_by(Année)%>%count(CritAir) %>% ggplot(aes(x=Année,y=n,fill=factor(CritAir)))+geom_bar(stat="identity")+scale_fill_manual(values=c("#a5fc03","green","yellow","orange","red","black"))+theme(axis.text.x=element_text(angle=90))+ggtitle("Répartition CritAir par Année")
  })
  
  
}
