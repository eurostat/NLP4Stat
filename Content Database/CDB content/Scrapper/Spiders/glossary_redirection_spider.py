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
                   'PWD=30gFcpQzj7sPtRu5bkes')
cursor = c.cursor()


class glossaryRedirectionSpider(scrapy.Spider):

    name = "glossaryRedirection"

    custom_settings = {
        # limit the logs
        'LOG_LEVEL': logging.WARNING,
        
    }

    start_urls = ['https://ec.europa.eu/eurostat/statistics-explained' +
                  '/index.php?title=Category:Glossary']

   

    def parse(self, response):
        for link in response.xpath("//div[@id='mw-pages']//div[@class='mw-category']//a[@class='mw-redirect']/@href"):
            if link.get().startswith('/eurostat'):
                cptRedirectLink = 'https://ec.europa.eu' + link.get()
            else:
                cptRedirectLink = link.get()
            yield scrapy.Request(url=link, callback=self.parse_redirect_links)

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


    def parse_redirect_links(self, response):
        # html page
        pageContent = response.css('#mw-content-text').get()
        
        if pageContent is not None:
            pageContent = BeautifulSoup(pageContent,
                                        'html.parser')

            # split around the part titles (ex: Related concepts , etc.)
            # list of strings (html)
            splitContent = re.split('<h2>|</h2>', pageContent.prettify())

            titleRaw = normalize(response.css('#firstHeading::text').get())
            redirected = response.css('.mw-redirectedfrom').css('a ::attr(title)').get()

            if splitContent[0] == titleRaw :
                splitContent.pop(0)

            elmntRedirected = Glossary()
            elmntRedirected['url'] = response.request.url.encode('utf-8')
            # check if already exists in DB
            cursor.execute(estatLinkSelectId(), elmntRedirected['url'])
            c.commit()
            row = cursor.fetchone()
            # if it does not exist
            if row is None:

                if redirected is not None:
                    print(redirected)
                    elmntRedirected['original_title'] = redirected.replace('Glossary:', '').encode('utf-8')

                    cursor.execute(estatLinkInsert(), elmntRedirected['original_title'], elmntRedirected['url'])
                    c.commit()
                    # get id
                    cursor.execute(estatLinkSelectId(), elmntRedirected['url'])
                    c.commit()
                    row = cursor.fetchone()
                    elmntRedirected['id'] = row.id

                    elmntRedirected['title'] = titleRaw.replace('Glossary:', '').encode('utf-8')
            
                    if elmntRedirected['title'] is None:
                        elmntRedirected['title'] = 'ERROR'

                    # get id of the element fitting the redirection
                    cursor.execute(estatLinkTitleSelectId(), elmntRedirected['title'])
                    c.commit()
                    row = cursor.fetchone()

                    if row is not None:
                        glossaryId = row.id

                        # insert redirection
                        if glossaryId is not None:
                            cursor.execute(redirectionInsert(), glossaryId, elmntRedirected['id'])
                            c.commit()

            else:
                elmntRedirected['id'] = row.id

                elmntRedirected['title'] = titleRaw.replace('Glossary:', '').encode('utf-8')
            
                if elmntRedirected['title'] is None:
                    elmntRedirected['title'] = 'ERROR'

                # get id of the element fitting the redirection
                cursor.execute(estatLinkTitleSelectId(), elmntRedirected['title'])
                c.commit()
                row = cursor.fetchone()
                if row is not None:
                    glossaryId = row.id

                    # insert redirection
                    if glossaryId is not None:

                        cursor.execute(redirectionCheck(), glossaryId, elmntRedirected['id'])
                        c.commit()
                        row = cursor.fetchone()
                        if row is not None:

                            cursor.execute(redirectionInsert(), glossaryId, elmntRedirected['id'])
                            c.commit()
