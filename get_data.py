from Scraper.CentraleAutoScraping.CentraleAutoScraping.spiders import LaCentraleScraper
import requests
from scrapy.crawler import CrawlerProcess

#Le Scraping de 5 pages prend environ 1 min 30 s
n_pages=1

#Attention prendre en compte le temps que cela peut prendre
#Et faire une copie du fichier csv initial avant de relancer, sinon effacé et remplacé
#Le fichier généré s'appellera data_2.csv
LaCentraleScraper.start_crawling(n_pages)


#Et récupération du fichier json nécessaire au tracé de la carte
url = 'https://france-geojson.gregoiredavid.fr/repo/departements.geojson'
r = requests.get(url, allow_redirects=True)

open('data/departement.json', 'wb').write(r.content)

