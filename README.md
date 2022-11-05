# Les voitures d'occasion en France
![GitHub contributors](https://img.shields.io/github/contributors/Leralix/ProjetR?label=Contributeur)

# Sommaire:

1. [Guide Utilisateur ](#user)
2. [Guide développeur ](#dev)
3. [Analyse résultat ](#analyse)


<a name="user">

## Guide utilisateur

### Introduction
<p>Ce git propose un Dashboard en R permettant de visualiser un grand nombre de voitures d'occasion et leurs caractéristiques, permettant ainsi de tirer des conclusions. </p>
<p> Les données ont été obtenues en scrapping à l'aide de 'scrapy' en Python, le processus peut se faire quand on veux pour réactualiser les données. </p>

<br>

### Données utilisées 
<p>Les données utilisées pour établir la base de donnée proviennent du site "La Centrale" : </p><a>https://www.lacentrale.fr/ </a>
<p>Pour ce qui est des données géolocalisées des départements, elles ont été obtenues sur "FranceGEOJSON" : </p> <a> https://france-geojson.gregoiredavid.fr/ </a>
<p>Le lien entre le fichier .json des départements et des données récupérées se fera dans le script R.</p>

<br>


### Installation
<p>Pour installer ce projet, il faut cloner le projet à l'aide de la commande</p>
<br>
<code>
$ git clone URLProjet
</code>
<br>
<br>
<p>Ensuite, il faut installer les packages requis contenus dans le requirement.txt, il n'y a pas de commande particulière, il est possible de copier/coller le contenu du fichier dans l'envrionnement R.
</p>

### Démarrage
<p>Avant de lancer le dashboard, il est possible de récupérer les données en lancant le scraper et la récupération du json depuis le site avec :</p>
<code>
$ python get_data.py
</code>
<h2>Il n'est pas recommandé de le faire car cela prend du temps, et que les données présentes sont suffisantes</h2>
<p>(get_data.py execute le scraper et la récupération du json, donc bien réfléchir avant de l'éxécuter)</p>

<br>
<p>Une fois le projet cloné et les packages requis installés, le projet se lance en éxécutant :</p>
<code>
app.R
</code>
<p>Dans un environnement R</p>

### Utilisation
<p>Une fois le fichier app.R lancé, il est possible d'intéragir avec le dashboard par le biais de slider et de bouttons cliquables.</p>

<a name="dev">

## Guide développeur

<p> Le code du projet est organisé en plusieurs fichiers R, et les bases de données:</p>
<p>- app.r : permet l'éxécution du dashboard</p>
<p>- ui.r : contient la mise en place visuelle et son agencement du dashboard</p>
<p>- server.r : contient la création des graphiques et la manipulation des données</p>

<br>
<p>Si des modifications relatives au visuel doivent etre faites alors se référer au ui.r</p>
<p>Si des modifications/ajouts relatifs au graphiques doivent être faits alors se référer à server.r</p>

<br>
<p>Il est aussi possible d'intéragir avec la récupération de données du scraper.</p>
<p>Toute la récupération de données se passe dans 'spiders.py'</p>
<p>Toutes les options relatives à la récupération tel que : le délai des requêtes, la rotation d'IP... se trouve dans settings.py</p>

<a name="analyse">

## Analyse des résultats
<p>Les voitures vendues d'occasion sont de tout age, toute marque et de tout budget. En plus d'avoir une bonne vision des voitures d'occasion a voir, On peut affirmer que cela nous permet aussi d'avoir un aperçu assez fiable du parc automobile français.</p>

<p>Après étude avec le dashboard, on peut voir que finalement les voitures d'occasions anciennes peuvent avoir un impact considérable sur l'environnement</p>
<p>Car ce sont eux qui consomme le plus, qui ne passe plus le controle technique, et ne respecte plus les normes euros qui vont être difficile à vendre.</p>
<p>Il y a beaucoup de voitures ayant moins de 2 ans, paliant tous les défauts des vieilles voitures, réduisant ainsi leur chance d'achat ; ce qui laisse donc un bon nombre de voiture peu attractives sans aucune chance d'être acheté, et qui ne seront sûrement jamais recyclé.</p>

<br>
<p>En dehors de cet aspect là, il semble que les voitures récentes (<2 ans) soit le plus vendues, les utilisateurs souhaitent donc se débarasser de véhicule nouvellement acheté. </p>
<p>Cette tendance peut-être interprétée comme une volonté de changer voyant que par exemple l'éléctrique est plus économique</p>
<p>Mais cela constitue un affront au combat pour le climat, car les utilisateurs changent rapidement de véhicule, c'est la surconsommation.</p>
<p>Elles sont récentes, ont peu de kilométrages et sont pourtant aux normes européennes récentes.</p>
