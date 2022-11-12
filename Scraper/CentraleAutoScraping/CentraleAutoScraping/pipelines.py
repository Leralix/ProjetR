# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html

import string

class CentraleautoscrapingPipeline(object):
    def process_item(self, item, spider):

        emiss=item['Émissions_de_CO2']
        if emiss and emiss[-1] in string.ascii_uppercase:
            item['Émissions_de_CO2']=item['Émissions_de_CO2'][:-1]
            item['Classe_Emission']=emiss[-1]
        return item
