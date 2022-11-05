from Scraper.CentraleAutoScraping.CentraleAutoScraping.spiders import LaCentraleScraper

from scrapy.crawler import CrawlerProcess

#Le Scraping de 5 pages prend environ 1 min 30 s
n_pages=5

#Attention prendre en compte le temps que cela peut prendre
#Et faire une copie du fichier csv initial avant de relancer, sinon effacé et remplacé
#Le fichier généré s'appellera data.csv
LaCentraleScraper.start_crawling(n_pages)
