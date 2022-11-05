import scrapy
import time
from scrapy.crawler import CrawlerProcess
from scrapy.utils.project import get_project_settings
import os


from ..items import CentraleautoscrapingItem

"""Le Scraper qui va récupérer les données sur le site LaCentraleAuto
Classe définie à partir de scrapy.Spider"""

class LaCentraleAuto(scrapy.Spider):
    """Nom du Scraper"""
    name='CentraleScrap'

    #Défini l'URL de départ
    start_urls=["https://www.lacentrale.fr/listing"]


    #Constructeur par défaut de la classe
    #Paramètre : number_pages (int) (nombres de pages du site) que le scraper fouillera
    def __init__(self,number_pages:int):
        self.number_pages=number_pages


    #Méthode appelée en première
    #Récupère l'URL de toutes les pages qui vont être scrapées
    #Dépend de l'attribut 'number_pages'
    def parse(self,response):
        #Le nombre de pages est défini par l'attribut
        for i in range(0,int(self.number_pages)):
            #URL connu depuis le site, chaque page à le même seul la fin change
            url="https://www.lacentrale.fr/listing?makesModelsCommercialNames=&options=&page="+str(i)
            #url="https://www.lacentrale.fr/listing?customerFamilyCodes=PART&makesModelsCommercialNames=&options=&page="+str(i)

            #Une fois l'url crée, appelle un callback 'parse_allcars'
            yield scrapy.Request(url=url,callback=self.parse_allcars)


    #Méthode qui récupèrera le lien de chaques annonces de ventes
    def parse_allcars(self,response):

        #Pour chaque annonce de ventes
        for link_car in  response.css('div.searchCard'):
            #Récupère le lien de l'annonce
            link_contained=link_car.css('::attr(href)').get()
            url="https://www.lacentrale.fr/"+link_contained

            #Appelle un callback 'parse_page'
            yield scrapy.Request(url=url,callback=self.parse_page)


    #Récupère les données sur la page d'une annonce
    def parse_page(self,response):

        #Créer un objet relatif à l'annonce, sera le même pour chaque annonce.
        #Modèle de données pour chaque annonce
        item=CentraleautoscrapingItem()
        #Intialise tous les champs de l'item à '' pour ne pas avoir de problème
        item.set_all('')

        # Récupère la marque et le modèle de la voiture (nom complet)
        makeANDcar = response.xpath('normalize-space(//div[@class="cbm-title--page"]/text())').get().split(' ')
        #item['marque'] = makeANDcar[0]

        #Récupère la marque de la voiture uniquement
        marque=response.css('nav.cbm-breadcrumb li ::text')[3].get()

        #Rempli les champs correspondant de l'item avec traitement de la donnée
        item['marque']=marque

        #Rempli le nom du modèle en prenant le nom comlet en retirant le nom de la marque dedans
        item['modele']= ' '.join(makeANDcar).replace(marque.upper(),'').strip()

        #Récupère le prix et rempli le champs de l'item
        item['prix'] = response.xpath('normalize-space(//span[@class="cbm__priceWrapper"]/text())').get()

        #Récupère le niveau d'équipement s'il existe sinon rien
        try:
            item['niveau_equipement'] = response.css('div.cbm-equipmentLevel__wrapper a::text').get().strip()
        except:
            pass


        #Récupère le nom complet du modèle du véhicule
        item['nom_complet'] = response.css('h1.cbm-moduleInfos__informationListFirst::text').get()

        #Récupère les références de l'annonce
        references = response.xpath('normalize-space(//span[@class="headerSection-extraContent"]/text())').get().split("\xa0")

        #S'il y a moins de 2 références, il n'y a que la référence de l'annonce sinon il y a aussi la référence professionnelle
        if len(references)<2:
            item['ref_pro']=""
            item['ref_annonce']=references[0].split(":")[-1].strip()
        else:
            item['ref_pro']=references[0].split(":")[-1][:-1].strip()
            item['ref_annonce'] = references[1].split(":")[-1].strip()

        #all_infos= response.xpath('//div[@class="cbm-moduleInfos__informationList cbm-moduleInfos__info rmation_column_break"]//li//text()').getall()
        #all_infos=all_infos.remove('?')
        dic={}

        #Récupère toutes les informations (liste) relatives au véhicule (couleur, puissance, énergie) selon la manière dont elles sont mises sur le site
        if response.css('div.cbm-moduleInfos__informationList.cbm-moduleInfos__information_column_break li')!=[]:
            all_info=response.css('div.cbm-moduleInfos__informationList.cbm-moduleInfos__information_column_break li')
        else:
            all_info=response.css('div.cbm-moduleInfos__informationList li')

        #Pour chaque informations de la liste
        for infos in all_info:

            #On récupère son contenu
            info=infos.css('::text').getall()
            index_2pt=info.index(' : ')

            #Récupère le nom du champs
            field_name=str(info[:index_2pt][0]).replace(' ','_').replace('&','Et').replace('_(déclaratif)','').replace("'",'').replace('.','')
            #Et sa valeur associée
            field_content=''.join(info[index_2pt+1:])

            #Rempli un champs de l'item grâce à ces informations
            item[field_name]=field_content

        #Récupère le type de vendeur
        type_vendeur=response.css('section.cbm-moduleSeller div div h2::text').get().strip()

        #Si le vendeur est "Vendeur Particulier" alors récupère son nom et sa localisation (dpt)
        if type_vendeur=="Vendeur particulier":
            seller_name=response.css('div.cbm-sellerName h3::text').get().split('(dpt.')[0].strip()
            seller_localisation=response.css('div.cbm-sellerName h3::text').get().split('(dpt.')[-1].strip()[:-1]
        #Sinon récupère le nom de l'enseigne et sa localisation
        else:
            seller_name=response.css('div.cbm-sellerName h3::text').get()
            seller_localisation=response.css('div.cbm-outlet__information--title ::text').get().split('à')[-1].strip()


        #Rempli les champs de l'item selon les informations
        item['Nom_Vendeur'] = seller_name
        item['Localisation'] = seller_localisation
        item['Type_Vendeur'] = type_vendeur

        #Rempli le champs avec le lien de l'annonce pour la retrouver
        item['Lien']=response.url

        #Renvoi l'item issu de la page de l'annonce
        #Contient toutes les informations nécessaires
        #(Ligne du fichier de donnée)
        yield item



#Méthode permettant d'éxécuter le scraper depuis un autre fichier
#Paramètre : n_pages (int) (nombre de pages sur lequel le scraper va s'effectuer)
def start_crawling(n_pages):
    #Récupère les données contenues dans 'settings.py'
    #Nécessaire au fonctionnement du scraper pour ne pas être bannis (IP) et utiliser la rotation d'IP
    settings_file_path = 'Scraper.CentraleAutoScraping.CentraleAutoScraping.settings'  # The path seen from root, ie. from main.py
    os.environ.setdefault('SCRAPY_SETTINGS_MODULE', settings_file_path)
    settings=get_project_settings()

    #Lance le scraper sur les n_pages fournis en paramètre
    process = CrawlerProcess(settings)
    process.crawl(LaCentraleAuto,n_pages)
    process.start()




