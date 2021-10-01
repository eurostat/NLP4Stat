import scrapy
from scrapy.crawler import CrawlerProcess
from scrapy.crawler import Crawler
from scrapy.settings import Settings
from twisted.internet import reactor
from bs4 import BeautifulSoup

# buit in
import os 
import re
import logging
import sys
import pyodbc
import hashlib
import time
import pandas as pd
from datetime import datetime

sys.path.insert(0, 'NLP4Stat/Scrapper/')

# project class
from generic_functions import *
from Items.LinkInfo import LinkInfo
from Items.News import News
from sql_request import *

c = pyodbc.connect('DSN=nlp4stat;' +
                   'DBA=ESTAT;' +
                   'UID=dba;' +
                   'PWD=dba')
cursor = c.cursor()

class newsSpider(scrapy.Spider):
    name = 'news'

    custom_settings = {
        # limit the logs
        'LOG_LEVEL': logging.WARNING,
        'DOWNLOAD_DELAY': 1
    }

    start_urls = ['https://ec.europa.eu/eurostat/web/main/news/whats-new', 'https://ec.europa.eu/eurostat/web/main/news/euro-indicators']

    # go through all the news
    def parse(self, response):
        # Gather the links on the page
        # starting with the start_urls link
        for page in response.css('.product_item'):
            for link in page.css('a ::attr(href)'):
                newsLink = link.extract()
                time.sleep(2)
                if ('products-eurostat-news'):
                    yield scrapy.Request(url=newsLink, callback=self.parse_news)
                else:
                    #truc link_info! fonction sans parse
                    
                    time.sleep(2)

        # Check if there is another page
        # if so re-launch the parse function
        # with next_page url as start_urls
        nextPage = response.xpath("//li[contains(.//text(), 'Next')]" +
                                   "/@href").get()
        if nextPage is not None:
            yield scrapy.Request(url=nextPage, callback=self.parse)

    # get the information from one news
    def parse_news(self, response):

        news = News()

        news['url'] = response.request.url
        # check if already exists in DB
        cursor.execute(estatLinkSelectId(), news['url'])
        c.commit()
        row = cursor.fetchone()
        # if it does not exist
        if row is None:
            titleRaw = response.css('.asset-title::text').get()
            if titleRaw is not None:
                titleRaw = normalize(titleRaw)
                news['title'] = titleRaw.encode('utf-8')

            else:
                news['title'] = 'ERROR'

            cursor.execute(estatLinkTypeKnownInsert(),
                           news['title'],
                           news['url'],
                           44)
            c.commit()
            # get id
            cursor.execute(estatLinkSelectId(),
                           news['url'])
            c.commit()
            row = cursor.fetchone()
            news['id'] = row.id
        else:
            news['id'] = row.id
            cursor.execute(LinkTypeUpdate(),
                           44,
                           row.id)

        # publication_date
        pubStrRaw = response.xpath('//p[@class="pubinfo"]').get()
        if pubStrRaw is not None:
            dateFormat = "%d/%B/%Y"
            update = datetime.strptime(pubStrRaw, dateFormat)
            news['publication_date'] = update

        # check if already in DB
        cursor.execute(newsSelect(), news['id'])
        c.commit()
        row = cursor.fetchone()
        if row is None:

            if pubStrRaw is not None:
                cursor.execute(newsFullInsert(),
                               news['id'],
                               news['publication_date'])
            else:
                cursor.execute(newsInsert(),
                               news['id'])
            c.commit()

            # Contenu
            bodyRaw = response.xpath('//div[@class="article_content"]/*').getall()
            sizebody = len(bodyRaw) - 3 #get rid of "To contact us"
            body = ""

            possibilities = ['[Ff]or more information', 
                     '[Ff]or further informarion', 
                     '[fF]urther information', 
                     '[Gg]o and have a look', 
                     '[dD]iscover them here']

            for possibilty in possibilities:
                if possibility in (bodyRaw[-4] or bodyRaw[-5]):
                    sizebody = len(bodyRaw) - 5
                    bodyLinks = BeautifulSoup(bodyRaw[-4], 'html.parser')
                    urls = bodyLinks.find_all('a')
                    for url in urls:
                        link = LinkInfo()
                        # cleaning the url
                        url = url.get('href')
                        if "oldid" not in url:
                            urlClean = url
                        else:
                            urlClean = re.split('&oldid', url)[0]

                        if urlClean.startswith('/eurostat'):
                             link['url'] = 'https://ec.europa.eu' + urlClean
                        else:
                             link['url'] = urlClean
                        link['title'] = url.get_text().encode('utf-8')
                        # check if already exist in LinkInfo
                        cursor.execute(estatLinkSelectId(),
                        link['url'])
                        c.commit()
                        row = cursor.fetchone()
                        if row is None:
                            cursor.execute(estatLinkInsert(),
                                            link['title'],
                                            link['url'])
                            c.commit()
                            # get id
                            cursor.execute(estatLinkSelectId(),
                                            link['url'])
                            c.commit()
                            row = cursor.fetchone()
                            # add a link between the figure and the paragraph
                            cursor.execute(moreInfoInsert(),
                                            news['id'], row.id)
                            c.commit()
                        else:
                            idLink = row.id
                            cursor.execute(moreInfoCheck(),
                                            news['id'], idLink)
                            c.commit()
                            row = cursor.fetchone()
                            if row is None:
                                # add link between the concept and the doc
                                cursor.execute(moreInfoInsert(),
                                                news['id'], idLink)
                    else:
                        # check if already exist in LinkInfo
                        cursor.execute(foreignLinkSelectId(),
                        link['url'])
                        c.commit()
                        row = cursor.fetchone()
                        if row is None:
                            cursor.execute(foreignLinkInsert(),
                                            link['title'],
                                            link['url'])
                            c.commit()
                            # get id
                            cursor.execute(foreignLinkSelectId(),
                                            link['url'])
                            c.commit()
                            row = cursor.fetchone()
                            # add a link between the figure and the paragraph
                            cursor.execute(moreInfoInsert(),
                                            news['id'], row.id)
                            c.commit()
                        else:
                            idLink = row.id
                            cursor.execute(moreInfoCheck(),
                                            news['id'], idLink)
                            c.commit()
                            row = cursor.fetchone()
                            if row is None:
                                # add link between the concept and the doc
                                cursor.execute(moreInfoInsert(),
                                                news['id'], idLink)


            for seg in bodyRaw:                
                body = body + seg.text() + " "

            news['body'] = body
            if body is not None:
                cursor.execute(newsUpdate(),
                               news['body'].encode('utf-8'),
                               news['id'])
                c.commit()

                


        yield news
