library(dplyr)
library(gapminder)
library(geojsonio)
library(broom)
library(treemapify)
library(tidyverse)

#Fichier définissant le création de tous les graphiques et élément visuels

#Transformation du fichier .csv en table utilisable en R
df <- read.table("./data/data.csv", header = TRUE, sep = ",", quote ='', dec = ".", fill = TRUE, comment.char = "")

#Déclaration d'une copie de df pour faire les opérations
da=df

#Transformation de données 'character' en 'int' pour être utilisable
#Les champs concernés sont : Emissions_de_C02, prix, Puissance_din
da$Émissions_de_CO2=as.integer(gsub("[a-z]","",gsub("/","",gsub(" ","",da$Émissions_de_CO2))))
da$prix=as.integer(parse_number(gsub(" ","",gsub("€","",da$prix))))
da$Puissance_din=as.integer(parse_number(da$Puissance_din))


#Mise en place des données pour créer une carte
#Fait en s'aidant de : https://r-graph-gallery.com/327-chloropleth-map-from-geojson-with-ggplot2.html
#Lecture du fichier json contenant les informations
spdf <- geojson_read("./data/departement.json",what="sp")
#Fortification de la table par région à l'aide de l'information "code"
spdf_fortified <- tidy(spdf,region="code")

#Calcul du nombre de ventes par régions et mis dans une nouvelle table
da_depart<- count(da,Localisation)
#Transformation de la donnée "Localisation" en character
da_depart$Localisation=as.character(da_depart$Localisation)

#Jointure de la table des Localisation et des données de ventes par régions
#Jointure entre le numéro de département 'Localisation' et l'id' du fichier json contenant cette information
spdf_fortified=spdf_fortified %>% left_join(.,da_depart,by=c("id"="Localisation"))

#Définition du server pour transmettre les informations des graphiques.
server <- function(input, output) {

  #Création d'un histogramme de la répartition des émissions de co2
  output$Repartition_Emission <- renderPlot({
      ggplot(da,aes(x=Émissions_de_CO2))+geom_histogram()+ggtitle("Répartition des émissions de CO2")+labs(x="Émissions de CO2 (en g/km)",y="Nombre de voitures")
  })
  
  
  #Création treemap du nombre de véhicules vendus par marques
  da_count=da%>%count(marque)
  da_count=da_count[order(da_count$n),]
  output$NbVehicule_Marque <- renderPlot({
    da_count%>%ggplot(aes(area=n,fill=factor(marque,levels=marque),label = paste(marque, n, sep = "\n")))+geom_treemap()+geom_treemap_text(colour = "white",place = "centre",size = 15) +theme(legend.position = "none")+scale_fill_viridis_d(option="A",direction=-1)+ggtitle("Nombre de véhicules mis en vente par marque")    
    })
  
  #Création diagramme ligne du nombre de voiture vendues selon leur année de mise en circulation
  output$NbVoiture_Per_Year <- renderPlot({
    da%>%count(Année)%>% ggplot(aes(x=Année,y=n))+geom_point()+geom_line()+ggtitle("Nombre de véhicules vendus selon leur année de mise en circulation")+labs(x="Année de mise en circulation",y="Nombre mis en vente")  
    })
  
  
  
  #Création pie_chart de la répartition des énergies employées
  output$PieChart_Energie <- renderPlot({
    da%>%count(Énergie)%>% ggplot(aes(x="",y=n,fill=Énergie))+      geom_bar(stat="identity",width=1,color="white")+ coord_polar("y",start=0)+theme_void()+ggtitle("Type de consommation des véhicules vendus (pie_chart)")
    })
  
  #Création bar chart de la répartition des énergies employées
  output$Bar_Energie <- renderPlot({
    da%>%count(Énergie)%>% ggplot(aes(x=n,y=Énergie,fill=Énergie))+      geom_bar(stat="identity",width=1,color="white")+geom_text(aes(label=n), color="black", size=3.5)+ggtitle("Type de consommation des véhicules vendus (bar_chart)")+labs(x="Nombre de voitures")
  })
  
  
  #Création bar_chart de la répartition des Crit'Air par marque
  output$CritAir_Marque <- renderPlot({
    da%>%group_by(marque)%>%count(CritAir) %>% ggplot(aes(x=marque,y=n,fill=factor(CritAir)))+geom_bar(stat="identity")+scale_fill_manual(name="Crit'Air",values=c("#a5fc03","green","yellow","orange","red","black"))+theme(axis.text.x=element_text(angle=90))+ggtitle("Répartition des CritAir par marque")+labs(x="Marque de voiture",y="Nombre de voitures")
  })
  
  #Création map du nombre de vente par régions
  output$Carte_NbVentes <- renderPlot({
    ggplot()+geom_polygon(data=spdf_fortified,aes(fill=n,x=long,y=lat,group=group))+theme_void()+coord_sf(xlim = c(-6,10),ylim=c(41,52))+scale_fill_viridis_b(option = "C",name="Nombre de véhicule mis en vente")+ggtitle("Carte du nombre de véhicule mis en vente")
    })
  
  #Créer un Pie_Chart du nombre de véhicules vendus par régions
  #D'abord création d'une nouvelle table comptant apparition de chaque 'Localisation'
  co = da%>%count(Localisation)
  #Là où total est inférieur à moitié du max, catégorisée comme 'Autre'
  co$Localisation[co$n < max(co$n)/2]="Autre"
  
  #Création du tracé en ayant unifié toutes les catégories et fait la somme de chaque (avec aggregate)
  ca=aggregate(co$n,by=list(co$Localisation),FUN=sum)
  ca=ca[order(ca$x),]
  tmp=ca[nrow(ca),]
  tmp2=ca[1:nrow(ca)-1,]
  ca[1,]=tmp
  ca[2:nrow(ca),]=tmp2
  
  output$Circular_Plot <- renderPlot({
    ca%>%ggplot(aes(x="",y=x,fill=factor(Group.1,levels=Group.1)))+geom_bar(stat="identity")+coord_polar("y",start=0)+theme_void()+scale_fill_viridis_d(direction=1,option="C",name="Département")+ggtitle("Nombre de véhicule mis en vente par département")
  })
  

  
  #Création diagramme bulle entre le prix et la puissance, par emission de co2
  output$Bubble_Emiss_Puiss_Prix <- renderPlot({
    da%>%group_by(Nombre_de_places)%>%ggplot(aes(x=prix,y=Puissance_din,size=abs(scale(Émissions_de_CO2))*10,color=Classe_Emission))+geom_point(alpha=0.5)+scale_color_brewer(palette="YlOrRd",name="Classe d'émission")+xlim(input$RangeBubbleGraph[1],input$RangeBubbleGraph[2])+labs(x="Prix",y="Puissance (en ch.)",size="Émission de CO2 (en g/km) (normalisé et multiplié par 10)")
  })
  
  
  #Création d'une fonction pour choisir un graph en fonction d'une entrée
  #Entrée : type ('character')
  #Sortie : un graphique dépendant de la valeur de type
  plotType <- function(type) {
    switch(type,
           #Si type vaut 'CritAir' alors renvoie ce graphique
           CritAir= da%>%ggplot(aes(x=Année,fill=as.factor(CritAir)))+geom_bar()+scale_fill_manual(values=c("#a5fc03","green","yellow","orange","red","black"))+ggtitle("Évolution du Crit'Air par année de mise en circulation des véhicule \n mis en vente")+labs(fill="Crit'Air",x="Année de mise en circulation",y="Nombre de voitures"),
           #Si type vaut 'Controle_technique' alors renvoie ce graphique
           Contrôle_technique = da%>%ggplot(aes(x=Année,fill=factor(Contrôle_technique)))+geom_bar()+scale_fill_manual(values=c("green","red","grey"))+ggtitle("Évolution de la nécessité du contrôle technique par année de mise \n en circulation des véhicule mis en vente")+labs(fill="Contrôle technique",x="Année de mise en circulation",y="Nombre de voitures"),
           #Si type vaut 'Classe_Emission' alors renvoie ce graphique
           Classe_Emission=da%>%ggplot(aes(x=Année,fill=factor(Classe_Emission)))+geom_bar()+scale_fill_manual(values=c("grey","#a5fc03","green","yellow","orange","darkorange3","red","black"))+ggtitle("Évolution de la classe d'émission par année \n de mise en circulation des véhicule mis en vente")+labs(fill="Classe d'émission",x="Année de mise en circulation",y="Nombre de voitures"),
           #Si type vaut 'Norme_Euro' alors renvoie ce graphique
           Norme_Euro=da%>%ggplot(aes(x=Année,fill=factor(Norme_Euro)))+geom_bar()+scale_fill_manual(values=c("grey","#a5fc03","green","yellow","orange","darkorange3","red"))+ggtitle("Évolution de la Norme Euro par année de \n mise en circulation des véhicule mis en vente")+labs(fill="Norme Euro",x="Année de mise en circulation",y="Nombre de voitures")
           )
  }
  
  #Création du graphique dépendant du renvoie de la fonction ci-dessus
  output$Multiple_Histo <- renderPlot({
    plotType(input$choice)
  })
  
  
  #Création d'une fonction pour choisir un graph en fonction d'une entrée
  #Entrée : type ('character')
  #Sortie : un graphique dépendant de la valeur de type
  plotType2 <- function(type) {
    switch(type,
           #Si type vaut 'CritAir' alors renvoie ce graphique
           CritAir= da[da$Année >= 2000, ]%>%group_by(Année)%>%count(CritAir) %>% ggplot(aes(x=Année,y=n,fill=factor(CritAir)))+geom_bar(stat="identity", position="fill")+scale_fill_manual(values=c("#a5fc03","green","yellow","orange","red","black"))+theme(axis.text.x=element_text(angle=90))+ggtitle("Évolution du Crit'Air par année de mise en circulation des véhicule \n mis en vente (à partir des années 2000)")+labs(fill="Crit'Air",x="Année de mise en circulation",y="Nombre de voitures"),
           #Si type vaut 'Controle_technique' alors renvoie ce graphique
           Contrôle_technique = da[da$Année >= 2000, ]%>%group_by(Année)%>%count(Contrôle_technique) %>% ggplot(aes(x=Année,y=n,fill=factor(Contrôle_technique)))+geom_bar(stat="identity", position="fill")+theme(axis.text.x=element_text(angle=90))+scale_fill_manual(values=c("green","red","grey"))+ggtitle("Évolution de la nécessité du contrôle technique par année de mise en \n circulation des véhicule mis en vente (à partir des années 2000)")+labs(fill="Contrôle technique",x="Année de mise en circulation (à partir des années 2000)",y="Nombre de voitures"),
           #Si type vaut 'Classe_Emission' alors renvoie ce graphique
           Classe_Emission=da[da$Année >= 2000, ]%>%group_by(Année)%>%count(Classe_Emission) %>% ggplot(aes(x=Année,y=n,fill=factor(Classe_Emission)))+geom_bar(stat="identity", position="fill")+theme(axis.text.x=element_text(angle=90))+scale_fill_manual(values=c("grey","#a5fc03","green","yellow","orange","darkorange3","red","black"))+ggtitle("Évolution de la classe d'émission par année de \n mise en circulation des véhicule mis en vente (à partir des années 2000)")+labs(fill="Classe d'émission",x="Année de mise en circulation",y="Nombre de voitures"),
           #Si type vaut 'Norme_Euro' alors renvoie ce graphique
           Norme_Euro=da[da$Année >= 2000, ]%>%group_by(Année)%>%count(Norme_Euro) %>% ggplot(aes(x=Année,y=n,fill=factor(Norme_Euro)))+geom_bar(stat="identity", position="fill")+theme(axis.text.x=element_text(angle=90))+scale_fill_manual(values=c("grey","#a5fc03","green","yellow","orange","darkorange3","red"))+ggtitle("Évolution de la Norme Euro par année de mise en \n circulation des véhicule mis en vente (à partir des années 2000)")+labs(fill="Norme Euro",x="Année de mise en circulation (à partir des années 2000)",y="Nombre de voitures")
    )
  }
  

  #Création du graphique dépendant du renvoie de la fonction ci-dessus
  output$Multiple_Histo2 <- renderPlot({
    plotType2(input$choice)
  })
  
   


  
  


  
  
}
