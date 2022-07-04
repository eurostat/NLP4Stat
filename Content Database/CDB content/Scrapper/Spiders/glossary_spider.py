import scrapy
from scrapy.crawler import CrawlerProcess
from scrapy.crawler import Crawler
from scrapy.settings import Settings
from twisted.internet import reactor
from bs4 import BeautifulSoup

# buit in
import sys
import os
import re
import logging
import pyodbc
import hashlib
import pandas as pd
from datetime import datetime

sys.path.insert(0, '/nlp4_eurostat/Scrapper/')

# project class
from generic_functions import normalize
from Items.LinkInfo import LinkInfo
from Items.Glossary import Glossary
from sql_request import *

c = pyodbc.connect('DSN=Virtuoso All;' +
                   'DBA=ESTAT;' +
                   'UID=dba;' +
                   'PWD=dba')
cursor = c.cursor()

class glossarySpider(scrapy.Spider):

    name = "glossary"

    custom_settings = {
        # limit the logs
        'LOG_LEVEL': logging.WARNING,
        
    }

    start_urls = ['https://ec.europa.eu/eurostat/statistics-explained' +
                  '/index.php?title=Category:Glossary']

   

    def parse(self, response):
        # Gather the links on the page
        # starting with the start_urls link
        for link in response.xpath("//div[@id='mw-pages']//div[@class='mw-category']//a[not(@class)]/@href"):
            if link.get().startswith('/eurostat'):
                cptLink = 'https://ec.europa.eu' + link.get()
            else:
                cptLink = link.get()
            yield scrapy.Request(url=cptLink, callback=self.parse_glossary)

        # Check if there is another page
        # if so re-launch the parse function
        # with nextPage url as start_urls
        nextPage = response.xpath("//div[@id='mw-pages']//a[contains(.//text(), 'next page')]" +
                                  "/@href").get()

        
        if nextPage is not None:
            if nextPage.startswith('/eurostat'):
                nextPageUrl = 'https://ec.europa.eu' + nextPage
            else:
                nextPageUrl = nextPage
            yield scrapy.Request(url = nextPageUrl, callback=self.parse)


    def parse_glossary(self, response):

        # html page
        pageContent = response.css('#mw-content-text').get()
        
        if pageContent is not None:
            pageContent = BeautifulSoup(pageContent,
                                        'html.parser')

            # split around the part titles (ex: Related concepts , etc.)
            # list of strings (html)
            splitContent = re.split('<h2>|</h2>', pageContent.prettify())

            titleRaw = normalize(response.css('#firstHeading::text').get())

            if splitContent[0] == titleRaw :
                splitContent.pop(0)

            definitionRaw = BeautifulSoup(splitContent[0], 'html.parser')

            glossary = Glossary()
            glossary['url'] = response.request.url.encode('utf-8')
            # check if already exists in DB
            cursor.execute(estatLinkSelectId(), glossary['url'])
            c.commit()
            row = cursor.fetchone()
            # if it does not exist
            if row is None:

                glossary['title'] = titleRaw.replace('Glossary:', '').encode('utf-8')
            
                if glossary['title'] is None:
                    glossary['title'] = 'ERROR'

                cursor.execute(estatLinkInsert(), glossary['title'], glossary['url'])
                c.commit()
                # get id
                cursor.execute(estatLinkSelectId(), glossary['url'])
                c.commit()
                row = cursor.fetchone()
                glossary['id'] = row.id
            else:
                glossary['id'] = row.id

            # last update
            updateStrRaw = response.xpath('//div[@id="footer"]' +
                                          '//li[@id="footer-info-lastmod"]/text()').get()
            if updateStrRaw is not None:
                dateFormat = "%d %B %Y, at %H:%M."
                updateStr = re.split('edited on ', normalize(updateStrRaw))
                update = datetime.strptime(updateStr[-1], dateFormat)
                glossary['last_update'] = update

            # check if already in DB
            cursor.execute(glossarySelect(), glossary['id'])
            c.commit()
            row = cursor.fetchone()
            if row is None:

                glossary['definition'] = normalize(definitionRaw.get_text()).encode('utf-8')

                if updateStrRaw is not None:
                    cursor.execute(glossaryFullInsert(),
                                       glossary['id'],
                                       glossary['definition'],
                                       glossary['last_update'])
                
                else:
                    cursor.execute(glossaryInsert(),
                                        glossary['id'],
                                        glossary['definition'])

                
                c.commit()

                glossary['further_info'] = []
                glossary['related_concepts'] = []
                glossary['statistical_data'] = []
                glossary['sources'] = []

                # to identify which sub-categories are in the page
                titlesList = pageContent.find_all('h2')

                # go through each sub-category to assign the right data
                # to the right category
                # if a new/undetected sub-category has to be added,
                # add an elif paragraph
                for i in range(len(titlesList)):
                    # index to gather the right info from splitContent
                    a = 2*i + 2
                    titleTemp = normalize(titlesList[i].get_text())
                    if 'Further information' in titleTemp:
                        for elmt in BeautifulSoup(splitContent[a],
                                                  'html.parser').find_all('a'):
                            furtherInfo = LinkInfo()
                            furtherInfo['title'] = normalize(elmt.get_text()).encode('utf-8')
                            url = elmt.get('href')
                            if "oldid" not in url:
                                urlClean = url
                            else:
                                urlClean = re.split('&oldid', url)[0]

                            if urlClean.startswith('/eurostat'):
                                furtherInfo['url'] = 'https://ec.europa.eu' + urlClean
                            else:
                                furtherInfo['url'] = urlClean
                            # select, check if in Link Info
                            if 'eurostat' in furtherInfo['url']:
                                cursor.execute(estatLinkSelectId(),
                                               furtherInfo['url'])
                                c.commit()
                                row = cursor.fetchone()

                                if row is None:
                                    # add a document
                                    cursor.execute(estatLinkInsert(),
                                                   furtherInfo['title'],
                                                   furtherInfo['url'])
                                    c.commit()
                                    # get id
                                    cursor.execute(estatLinkSelectId(),
                                                   furtherInfo['url'])
                                    c.commit()
                                    row = cursor.fetchone()
                                    # add a link between the concept and the doc
                                    cursor.execute(furtherInfoInsert(),
                                                   glossary['id'],
                                                   row.id)
                                    c.commit()
                                else:
                                    idLink = row.id
                                    cursor.execute(furtherInfoCheck(),
                                                   glossary['id'],
                                                   idLink)
                                    c.commit()
                                    row = cursor.fetchone()
                                    if row is None:
                                        # add link between the concept and the doc
                                        cursor.execute(furtherInfoInsert(),
                                                       glossary['id'],
                                                       idLink)

                            else:
                                cursor.execute(foreignLinkSelectId(),
                                               furtherInfo['url'])
                                c.commit()
                                row = cursor.fetchone()

                                if row is None:
                                    # add a document
                                    cursor.execute(foreignLinkInsert(),
                                                   furtherInfo['title'],
                                                   furtherInfo['url'])
                                    c.commit()
                                    # get id
                                    cursor.execute(foreignLinkSelectId(),
                                                   furtherInfo['url'])
                                    c.commit()
                                    row = cursor.fetchone()
                                    # add a link between the concept and the doc
                                    cursor.execute(furtherInfoInsert(),
                                                   glossary['id'],
                                                   row.id)
                                    c.commit()
                                else:
                                    idLink = row.id
                                    cursor.execute(furtherInfoCheck(),
                                                   glossary['id'],
                                                   idLink)
                                    c.commit()
                                    row = cursor.fetchone()
                                    if row is None:
                                        # add link between the concept and the doc
                                        cursor.execute(furtherInfoInsert(),
                                                       glossary['id'],
                                                       idLink)

                            glossary['further_info'].append(furtherInfo)

                    elif 'Related concepts' in titleTemp:
                        for elmt in BeautifulSoup(splitContent[a],
                                                  'html.parser').find_all('a'):
                            relCpt = LinkInfo()
                            relCpt['title'] = normalize(elmt.get_text()).encode('utf-8')
                            urlCpt = elmt.get('href')
                            if "oldid" not in urlCpt:
                                urlCptClean = urlCpt
                            else:
                                urlCptClean = re.split('&oldid', urlCpt)[0]

                            if urlCptClean.startswith('/eurostat'):
                                relCpt['url'] = 'https://ec.europa.eu' + urlCptClean
                            else:
                                relCpt['url'] = urlCptClean
                            # check if the doc already is in the DB
                            cursor.execute(estatLinkSelectId(), relCpt['url'])
                            c.commit()
                            row = cursor.fetchone()

                            if row is None:
                                # add a document
                                cursor.execute(estatLinkInsert(),
                                               relCpt['title'],
                                               relCpt['url'])
                                c.commit()
                                # get id
                                cursor.execute(estatLinkSelectId(),
                                               relCpt['url'])
                                c.commit()
                                row = cursor.fetchone()
                                # add a link between the concept and the doc
                                cursor.execute(relCptInsert(),
                                               glossary['id'],
                                               row.id)
                                c.commit()
                            else:
                                idLink = row.id
                                cursor.execute(relCptCheck(),
                                               glossary['id'],
                                               idLink)
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    # add a link between the concept and the doc
                                    cursor.execute(relCptInsert(),
                                                   glossary['id'],
                                                   idLink)

                            glossary['related_concepts'].append(relCpt)

                    elif 'Statistical data' in titleTemp:
                        for elmt in BeautifulSoup(splitContent[a],
                                                  'html.parser').find_all('a'):
                            statData = LinkInfo()
                            statData['title'] = elmt.get('title')
                            urlStat = elmt.get('href')
                            if "oldid" not in urlStat:
                                urlStatClean = urlStat
                            else:
                                urlStatClean = re.split('&oldid', urlStat)[0]

                            if urlStatClean.startswith('/eurostat'):
                                statData['url'] = 'https://ec.europa.eu' + urlStatClean
                            else:
                                statData['url'] = urlStatClean
                            # check if the doc already is in the DB
                            cursor.execute(estatLinkSelectId(),
                                           statData['url'])
                            c.commit()
                            row = cursor.fetchone()

                            if row is None:
                                if statData['title'] is None:
                                    statData['title'] = statData['url']

                                # add a document
                                cursor.execute(estatLinkInsert(),
                                               statData['title'].encode('utf-8'),
                                               statData['url'])
                                c.commit()
                                # get id
                                cursor.execute(estatLinkSelectId(),
                                               statData['url'])
                                c.commit()
                                row = cursor.fetchone()
                                # add a link between the concept and the doc
                                cursor.execute(statDataInsert(),
                                               glossary['id'],
                                               row.id)
                                c.commit()
                            else:
                                idLink = row.id
                                cursor.execute(statDataCheck(),
                                               glossary['id'],
                                               idLink)
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    # add link between the concept and the doc
                                    cursor.execute(statDataInsert(),
                                                   glossary['id'],
                                                   idLink)
                            glossary['statistical_data'].append(statData)

                    elif 'Source' in titleTemp:
                        for elmt in BeautifulSoup(splitContent[a],
                                                  'html.parser').find_all('a'):
                            source = LinkInfo()
                            source['title'] = normalize(elmt.get_text()).encode('utf-8')
                            url = elmt.get('href')
                            if "oldid" not in url:
                                urlClean = url
                            else:
                                urlClean = re.split('&oldid', url)[0]
                            if urlClean.startswith('/eurostat'):
                                source['url'] = 'https://ec.europa.eu' + urlClean
                            else:
                                source['url'] = urlClean
                            # select, check if in Link Info
                            if 'eurostat' in source['url']:
                                cursor.execute(estatLinkSelectId(),
                                               source['url'])
                                c.commit()
                                row = cursor.fetchone()

                                if row is None:
                                    # add a document
                                    cursor.execute(estatLinkInsert(),
                                                   source['title'],
                                                   source['url'])
                                    c.commit()
                                    # get id
                                    cursor.execute(estatLinkSelectId(),
                                                   source['url'])
                                    c.commit()
                                    row = cursor.fetchone()
                                    # add a link between the concept and the doc
                                    cursor.execute(sourceInsert(),
                                                   glossary['id'],
                                                   row.id)
                                    c.commit()
                                else:
                                    idLink = row.id
                                    cursor.execute(sourceCheck(),
                                                   glossary['id'],
                                                   idLink)
                                    c.commit()
                                    row = cursor.fetchone()
                                    if row is None:
                                        # add link between the concept and the doc
                                        cursor.execute(sourceInsert(),
                                                       glossary['id'],
                                                       idLink)

                            else:
                                cursor.execute(foreignLinkSelectId(),
                                               source['url'])
                                c.commit()
                                row = cursor.fetchone()

                                if row is None:
                                    # add a document
                                    cursor.execute(foreignLinkInsert(),
                                                   source['title'],
                                                   source['url'])
                                    c.commit()
                                    # get id
                                    cursor.execute(foreignLinkSelectId(),
                                                   source['url'])
                                    c.commit()
                                    row = cursor.fetchone()
                                    # add a link between the concept and the doc
                                    cursor.execute(sourceInsert(),
                                                   glossary['id'],
                                                   row.id)
                                    c.commit()
                                else:
                                    idLink = row.id
                                    cursor.execute(sourceCheck(),
                                                   glossary['id'],
                                                   idLink)
                                    c.commit()
                                    row = cursor.fetchone()
                                    if row is None:
                                        # add link between the concept and the doc
                                        cursor.execute(sourceInsert(),
                                                       glossary['id'],
                                                       idLink)

                            glossary['sources'].append(source)

                categories = response.xpath('//div[@id="mw-normal-catlinks"]' +
                                            '/ul/li/a/text()').getall()

                glossary['categories'] = categories
            # elif row.last_update == glossary['last_update']:
                # To complete in order to update the DB

            yield glossary

    
