library(ggplot2)


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Les ventes de voitures d'occasion en France et l'impact écologique"),
  
  fluidRow(
    p("Pour commencer nous pouvons analyser la réparition de nos données, avec certains graphiques"),
      tabsetPanel(
        tabPanel(
          "Infos",
            p("La table possède ",nrow(da)," lignes de données, pour ",ncol(da)," colonnes de données."),
            p("Ce dashboard vise à observer le phénomène de la vente de véhicule d'occasion et en tirer des conclusions et en faire un lien avec son impact environnemental"),
            p("Les données ont été scrapées depuis le site 'La Centrale Auto' de manière respectueuse.")
          
          
        ),
        tabPanel(
          "Répartition des relevés",
          sidebarLayout(
            sidebarPanel(
              p("On peut observer la répartition des véhicules vendus et voir quelle marque sont plus vendues que les autres.")
            ),
            mainPanel(
              plotOutput(outputId = "NbVehicule_Marque")
            ),
          ),
          
        ),
        tabPanel(
          "Vente par année de mise en circulation",
          sidebarLayout(
            sidebarPanel(
              p("On peut aussi observer le nombre de véhicules mis en vente selon leur année de mise en circulation."),
              p("Et on peut constater que la tendance est un plus grand nombre de véhicule récent au dépens de ceux plus vieux."),
              p("Cette tendance aura donc un impact sur les interprétations faites.")
            ),
            mainPanel(
              plotOutput(outputId = "NbVoiture_Per_Year")
            ),
          ),
          
        )
      )
    ),
    
  
  titlePanel("Emissions de CO2"),

  sidebarLayout(
    mainPanel(
    plotOutput(outputId = "Repartition_Emission"),
    ),
    sidebarPanel(
    p("On peut voir la majorité des véhicules vendus ont une émission de 120 g/km."),
    p("Et que finalement l'éléctrique située à 0 prend un part non négligeable par rapport aux autres intervalles d'émissions")
  
    )),


  
  titlePanel("Répartition des types de consommation"),
fluidRow(
  splitLayout(
    plotOutput(outputId = "PieChart_Energie"),
    plotOutput(outputId = "Histo_Energie")
  ),
  p("La majorité des véhicules vendus fonctionnent principalement au Diesel et à l'Essence."),
  p("Très peu de véhicules éléctriques sont vendus.")
),

titlePanel("Quelles sont les marques les moins responsables"),
sidebarLayout(
  sidebarPanel(
    p("On peut en interpréter 2 choses : "),
    p("Que beaucoup de personnes souhaitent se débarasser de leur Mercedes"),
    p("Et que ce sont principalement les grandes marques dont les gens souhaitent vendre des véhicules au Crit'Air élevé"),
    p("Particulièrement les marques deluxes importées des pays étrangers."),
    p("Le score moyen Crit'Air semble être de 2")
  ),
  mainPanel(
  plotOutput(outputId = "CritAir_Marque"),
  )
),

titlePanel("Localisation des ventes"),
sidebarLayout(
  mainPanel(
  splitLayout(
    plotOutput(outputId = "Carte_NbVentes"),
    plotOutput(outputId = "Circular_Plot"),
    
  ),
  ),

  sidebarPanel(
    p("Les régions frontalières et centrales semblent être celles où les gens vendent leur voitures."),
    p("Mais cela reste en grande majorité dans la région parisienne, là où le véhicule est plus utilisé pour se déplacer malgré une présence transport en commun abondante."),
    p("Le nombre de ventes totales semble même concentrée dans la région parisienne")
    
  )
),
    

titlePanel("Lien entre prix, puissance et émission"),

  sidebarLayout(
    sidebarPanel(
    sliderInput(
      inputId = "RangeBubbleGraph",
      label="Prix",
      min=1000,
      max=300000,
      step=1,
      value=c(5000,10000),
      ticks=TRUE,
  ),
  p("Plus le prix de vente augmente, plus les véhicules semblent être puissant et consommé beaucoup et être mal classés"),
  p("Même si on peut observer que dans les prix bas, la puissance est moindre mais la consommation nettement plus basse"),
  p("Et même si le prix semble corrélé à l'émission du véhicule, on peut voir que le lien entre puissance et consommation et bien plus flagrant.")
    ),
  mainPanel(
  plotOutput(outputId = "Bubble_Emiss_Puiss_Prix")
  ),
  ),
  

titlePanel("Année du véhicule et lien avec son impact écologie"),
  sidebarLayout(
    
    sidebarPanel(
      radioButtons(
        inputId = "choice",
        label = "Choix de visualisation",
        c("CritAir",
          "Contrôle_technique",
          "Classe_Emission",
          "Norme_Euro"
      )
      
    ),
    p("Comme on peut s'y attendre, plus les véhicules sont vieux plus leur Crit'Air est mauvais et consomme plus"),
    p("Tous les véhicules d'avant 2017 n'ont pas passé le contrôle technique, et la plupart avant cette date ne respecte même plus les nouvelles normes européennes de consommation.")
    ),
    mainPanel(
      plotOutput(outputId = "Multiple_Histo")
    )
    
  ),

)