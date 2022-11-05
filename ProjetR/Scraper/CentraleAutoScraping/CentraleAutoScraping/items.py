# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class CentraleautoscrapingItem(scrapy.Item):
    # define the fields for your item here like:
    marque=scrapy.Field()
    modele=scrapy.Field()
    prix=scrapy.Field()
    niveau_equipement=scrapy.Field()
    nom_complet=scrapy.Field()
    ref_pro=scrapy.Field()
    ref_annonce=scrapy.Field()

    Année = scrapy.Field()
    Mise_en_circulation=scrapy.Field()
    Contrôle_technique=scrapy.Field()
    Kilométrage_compteur=scrapy.Field()
    Énergie=scrapy.Field()
    Boîte_de_vitesse=scrapy.Field()
    Couleur_extérieure=scrapy.Field()
    Couleur_intérieure=scrapy.Field()
    Nombre_de_portes=scrapy.Field()
    Nombre_de_places=scrapy.Field()
    Garantie=scrapy.Field()
    Vérifié_Et_Garanti=scrapy.Field()
    Première_main=scrapy.Field()
    Nombre_de_propriétaires=scrapy.Field()
    Puissance_fiscale=scrapy.Field()
    Puissance_din=scrapy.Field()
    CritAir=scrapy.Field()

    Émissions_de_CO2=scrapy.Field()
    Classe_Emission=scrapy.Field()

    Consommation_mixte=scrapy.Field()
    Norme_Euro=scrapy.Field()
    Prime_à_la_conversion=scrapy.Field()
    Garantie_constructeur=scrapy.Field()
    Rechargeable=scrapy.Field()
    Puissance_moteur=scrapy.Field()
    Provenance=scrapy.Field()
    Autonomie_constructeur=scrapy.Field()
    Capacité_batterie=scrapy.Field()
    Voltage_batterie=scrapy.Field()
    Intensité_batterie=scrapy.Field()
    Prix_inclut_la_batterie=scrapy.Field()
    Conso_batterie=scrapy.Field()

    Nom_Vendeur=scrapy.Field()
    Type_Vendeur=scrapy.Field()
    Localisation=scrapy.Field()

    Lien=scrapy.Field()

    pass

    def set_all(self,value):
        for keys,_ in self.fields.items():
            self[keys]=value