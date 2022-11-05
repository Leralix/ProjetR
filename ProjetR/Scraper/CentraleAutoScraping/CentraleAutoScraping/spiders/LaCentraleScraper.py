import scrapy
import time
from scrapy.crawler import CrawlerProcess
from scrapy.utils.project import get_project_settings
import os


from ..items import CentraleautoscrapingItem

class LaCentraleAuto(scrapy.Spider):
    name='CentraleScrap'

    start_urls=["https://www.lacentrale.fr/listing"]



    def __init__(self,number_pages:int):
        self.number_pages=number_pages


    def parse(self,response):
        for i in range(0,int(self.number_pages)):
            url="https://www.lacentrale.fr/listing?makesModelsCommercialNames=&options=&page="+str(i)
            #url="https://www.lacentrale.fr/listing?customerFamilyCodes=PART&makesModelsCommercialNames=&options=&page="+str(i)
            yield scrapy.Request(url=url,callback=self.parse_allcars)


    def parse_allcars(self,response):
        for link_car in  response.css('div.searchCard'):
            link_contained=link_car.css('::attr(href)').get()
            url="https://www.lacentrale.fr/"+link_contained
            yield scrapy.Request(url=url,callback=self.parse_page)


    def parse_page(self,response):

        item=CentraleautoscrapingItem()
        item.set_all('')

        """
        makeANDcar=response.xpath('normalize-space(//div[@class="cbm-title--page"]/text())').get().split(' ')
        marque=makeANDcar[0]
        modele=' '.join(makeANDcar[1:])
        prix=response.xpath('normalize-space(//span[@class="cbm__priceWrapper"]/text())').get()
        niveau_equipement=response.css('div.cbm-equipmentLevel__wrapper a::text').get().strip()
        nom_complet=response.css('h1.cbm-moduleInfos__informationListFirst::text').get()
        references= response.xpath('normalize-space(//span[@class="headerSection-extraContent"]/text())').get().split("\xa0")
        """

        makeANDcar = response.xpath('normalize-space(//div[@class="cbm-title--page"]/text())').get().split(' ')
        #item['marque'] = makeANDcar[0]
        marque=response.css('nav.cbm-breadcrumb li ::text')[3].get()
        item['marque']=marque
        item['modele']= ' '.join(makeANDcar).replace(marque.upper(),'').strip()

        item['prix'] = response.xpath('normalize-space(//span[@class="cbm__priceWrapper"]/text())').get()
        try:
            item['niveau_equipement'] = response.css('div.cbm-equipmentLevel__wrapper a::text').get().strip()
        except:
            pass

        item['nom_complet'] = response.css('h1.cbm-moduleInfos__informationListFirst::text').get()
        references = response.xpath('normalize-space(//span[@class="headerSection-extraContent"]/text())').get().split("\xa0")

        if len(references)<2:
            item['ref_pro']=""
            item['ref_annonce']=references[0].split(":")[-1].strip()
        else:
            item['ref_pro']=references[0].split(":")[-1][:-1].strip()
            item['ref_annonce'] = references[1].split(":")[-1].strip()

        #all_infos= response.xpath('//div[@class="cbm-moduleInfos__informationList cbm-moduleInfos__info rmation_column_break"]//li//text()').getall()
        #all_infos=all_infos.remove('?')
        dic={}

        if response.css('div.cbm-moduleInfos__informationList.cbm-moduleInfos__information_column_break li')!=[]:
            all_info=response.css('div.cbm-moduleInfos__informationList.cbm-moduleInfos__information_column_break li')
        else:
            all_info=response.css('div.cbm-moduleInfos__informationList li')

        for infos in all_info:
            info=infos.css('::text').getall()
            index_2pt=info.index(' : ')
            #dic[info[:index_2pt][0]]=''.join(info[index_2pt+1:])

            field_name=str(info[:index_2pt][0]).replace(' ','_').replace('&','Et').replace('_(déclaratif)','').replace("'",'').replace('.','')
            field_content=''.join(info[index_2pt+1:])

            item[field_name]=field_content
            """
            yield{
               str(info[:index_2pt][0]):''.join(info[index_2pt+1:])
            }
            """
        type_vendeur=response.css('section.cbm-moduleSeller div div h2::text').get().strip()

        if type_vendeur=="Vendeur particulier":
            seller_name=response.css('div.cbm-sellerName h3::text').get().split('(dpt.')[0].strip()
            seller_localisation=response.css('div.cbm-sellerName h3::text').get().split('(dpt.')[-1].strip()[:-1]



        else:
            seller_name=response.css('div.cbm-sellerName h3::text').get()
            seller_localisation=response.css('div.cbm-outlet__information--title ::text').get().split('à')[-1].strip()

            #Sous type de vendeur (Cntre multimarque, concessinnaire)
            #seller_type=response.css('ul.cbm-sellerInfos.cbm-list--2 li')[0].css('span ::text')[-1].get().strip()


        item['Nom_Vendeur'] = seller_name
        item['Localisation'] = seller_localisation
        item['Type_Vendeur'] = type_vendeur


        item['Lien']=response.url


        yield item
        """
        yield{
            "Marque":marque,
            "Modele":modele,
            "Prix":prix,
            "Niveau Equipement":niveau_equipement,
            "Nom Comlet":nom_complet,
            "Reference Pro":ref_pro,
            "Reference Annonce":ref_annonce,
        }
        """




def start_crawling(n_pages):
    settings_file_path = 'Scraper.CentraleAutoScraping.CentraleAutoScraping.settings'  # The path seen from root, ie. from main.py
    os.environ.setdefault('SCRAPY_SETTINGS_MODULE', settings_file_path)
    settings=get_project_settings()
    print(settings.get("CONCURRENT_REQUESTS"))
    process = CrawlerProcess(settings)
    process.crawl(LaCentraleAuto,n_pages)
    process.start()




