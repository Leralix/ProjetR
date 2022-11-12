#Fichier contenant toute les déclarations d'entrées comme les slider, et l'agencement visuel

library(ggplot2)

# Défini la page principale qui contiendra tout
ui <- fluidPage(
  #Titre du Dashboard
  titlePanel("Les ventes de voitures d'occasion en France et l'impact écologique"),
  #Panneau d'informations d'étude du jeu de données
  fluidRow(
    p("Pour commencer nous pouvons analyser la réparition de nos données, avec certains graphiques"),
      tabsetPanel(
        tabPanel(
          "Infos",
            p("La table possède lignes 825 de données, pour 43 colonnes de données. Chaque ligne représente un véhicule mis en vente."),
            p("Ce dashboard vise à observer le phénomène de la vente de véhicule d'occasion et en tirer des conclusions et en faire un lien avec son impact environnemental"),
            p("Les données ont été scrapées depuis le site 'La Centrale Auto' de manière respectueuse, et vont donc servir à la création de ce dashboard."),
            p("Quant à la création de la carte, on utilise un .json donné sur un site (lien sur le github).")
          
          
        ),
        tabPanel(
          "Répartition des ventes",
          sidebarLayout(
            sidebarPanel(
              p("On peut observer la répartition des véhicules vendus et voir quelles marque sont plus vendues que les autres.")
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
              p("Et on peut constater que la tendance est un plus grand nombre de véhicules récents mis en vente aux dépends de ceux plus vieux."),
              p("Cette tendance aura donc un impact sur les interprétations faites.")
            ),
            mainPanel(
              plotOutput(outputId = "NbVoiture_Per_Year")
            ),
          ),
          
        )
      )
    ),
    
  tags$hr(style="border-color: black;"),
  
  #Titre d'une sous partie
  titlePanel("Études des émissions de CO2"),
  #Ajout d'un graphique et du texte
  sidebarLayout(
    mainPanel(
    plotOutput(outputId = "Repartition_Emission"),
    ),
    sidebarPanel(
    p("On peut voir la majorité des véhicules vendus ont une émission de 120 g/km."),
    p("Et que finalement l'éléctrique située à 0 prend une part non négligeable par rapport aux autres intervalles d'émissions"),
    p("Ce chiffre représente la consommation moyenne d'un véhicule.")
  
    )),

  tags$hr(style="border-color: black;"),
  
  #Titre d'une sous partie
  titlePanel("Répartition des types de consommation"),
  
  #Ajout de graphique et de textes
  fluidRow(
    splitLayout(
      plotOutput(outputId = "PieChart_Energie"),
      plotOutput(outputId = "Bar_Energie")
              ),
    p("La majorité des véhicules vendus fonctionnent principalement au Diesel et à l'Essence."),
    p("Très peu de véhicules éléctriques sont vendus, car très utile et prohibés en France de nos jours. Il en va de même pour l'hybride qui reste aussi très peu vendu."),
    p("On comprend que les gens cherchent à se débarasser de véhicules qui consomment le plus et coûtent le plus cher de nos jours, et qui dans l'avenir seront difficile de circulation.")
    
    ),

  tags$hr(style="border-color: black;"),
  
  #Titre d'une sous partie
  titlePanel("Quelles sont les marques les moins responsables ?"),
    
  #Ajout de graphique et de texte
    sidebarLayout(
      sidebarPanel(
        p("On peut en interpréter 2 choses : "),
        p("Que beaucoup de personnes souhaitent se débarasser de leur Mercedes"),
        p("Et que ce sont principalement les grandes marques dont les gens souhaitent vendre leur véhicules, ce qui va de mèche avec le Crit'Air."),
        p("Particulièrement les marques deluxes importées des pays étrangers, et les marques n'ayant pas entamée leur transition écologique. Mercedes en est un exemple, la marque vend peu de véhicules éléctriques, et une bonne partie des véhicules mis en vente possèdent des Crit'Air élevés."),
        p("Le score moyen Crit'Air semble être de 2")
                   ),
    mainPanel(
      plotOutput(outputId = "CritAir_Marque"),
            )
                ),

    tags$hr(style="border-color: black;"),
  
  #Titre d'une sous partie
  titlePanel("La localisation des ventes"),
  #Ajout de graphique et de texte
  sidebarLayout(
    mainPanel(
      splitLayout(
        plotOutput(outputId = "Carte_NbVentes"),
        plotOutput(outputId = "Circular_Plot"),
                ),
              ),
    sidebarPanel(
      p("Les départements frontaliers et centrales semblent être ceux où les gens vendent le plus leur voiture."),
      p("Mais cela reste en grande majorité dans la région parisienne que le nombre de véhicule vendu est le plus grand, là où le véhicule est plus utilisé pour se déplacer malgré une présence transport en commun abondante."),
      p("Le nombre de ventes totales semble même concentrée dans la région parisienne.")
                )
              ),
    
  tags$hr(style="border-color: black;"),
  
  #Titre d'une sous partie
  titlePanel("Lien entre prix, puissance et émission"),
  #Ajout de graphique et de texte
  #Et d'une entrée : RangeSlider
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
    p("Plus le prix de vente augmente, plus les véhicules semblent être puissant, consommer beaucoup et être mal classés"),
    p("Et si on observe dans les prix bas, la puissance est moindre mais la consommation nettement plus basse"),
    p("Et même si le prix semble corrélé à l'émission du véhicule, on peut voir que le lien entre puissance et consommation et bien plus flagrant.")
    ),
  mainPanel(
    plotOutput(outputId = "Bubble_Emiss_Puiss_Prix")
          ),
        ),

  tags$hr(style="border-color: black;"),
  
  #Titre d'une sous partie
  titlePanel("Année du véhicule et lien avec son impact écologique"),
  #Ajout de graphique et de texte
  #Et d'une entrée RadioButton
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
      p("Tous les véhicules d'avant 2017 n'ont pas passé le contrôle technique, et la plupart avant cette date ne respecte même plus les nouvelles normes européennes de consommation."),
      p("Ces véhicules 'datés' seront compliqués à vendre, car leur entretien coûte plus cher, de même pour leur fonctionnement."),
        ),
    
      mainPanel(
        splitLayout(
      plotOutput(outputId = "Multiple_Histo"),
      plotOutput(outputId = "Multiple_Histo2"),
        ),
    ),
  ),
  
  tags$hr(style="border-color: black;"),
  titlePanel("Conclusion"),
  mainPanel(
    p("Que peut-on tirer de tout ces graphiques et données analysées ?"),
    p("Eh bien, la vente de véhicule d'ocassion semble assez problématique dans l'ensemble."),
    p("Le fait que la plupart des véhicules vendus datent d'il y a moins de 2 ans montre que les gens gardent très peu leur véhicules et changent rapidement, sûrement au profit d'un autre véhicule moins consommateur."),
    p("Si déjà cette tendance de véhicule récent peut consituter un affront contre le combat pour le climat, les véhicules assez vieux vont aussi constituer des problèmes dans le futur."),
    p("Même si il y a peu de véhicule assez vieux mis en vente, ils seront difficilement rachetés au vue des politiques adoptés et de l'évolution de notre mode de vie, la plupart ne respectant plus les normes et n'ayant pas passé le contrôle technique, se trouve finalement être des bombes à retardement financiaires."),
    p("L'achat d'un tel véhicule va impliquer des coûts bien au delà de son prix de vente, et si cette tendance continue il est possible qu'il ne soient jamais vendus."),
    
    
    p(""),
    p("En bref, la vente de véhicule d'occasion permet certes de 'recycler' son véhicule, ce qui est une très bonne intiative pour l'environnement, mais cette action semble être contrecarrer par le haut nombre de véhicule récent mis en vente ;"),
    p("Comme vue dans les graphiques, les véhicules consomme peu, on le contrôle technique, et les gens s'en débarassent."),
    p("On constate donc des effets contre-balancés.")
  ),

)