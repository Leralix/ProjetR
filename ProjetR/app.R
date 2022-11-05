#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Fichier principal permettant de lancer le dashboard

#Changement du répertoire courant pour pouvoir récupérer les fichiers à la racine pour l'éxécution
setwd(dirname(getwd()))

library(shiny)


#Importation des fichiers ui et server, contenant ce qui est nécessaire au bon lancement du dashboard
source('ui.R')
source('server.R')


# Lance l'application
#A l'aide de l'ui récupérer dans ui.R
#Et le server récupérer dans server.R
shinyApp(ui = ui, server = server)
