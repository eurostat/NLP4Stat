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
from Items.Concept import Concept
from sql_request import *

c = pyodbc.connect('DSN=VirtuosoKapcode;' +
                   'DBA=ESTAT;' +
                   'UID=XXXXX;' +
                   'PWD=XXXXXXXXXXXXXXX')
cursor = c.cursor()


class glossarySpider(scrapy.Spider):

    name = "glossary"

    custom_settings = {
        # limit the logs
        'LOG_LEVEL': logging.WARNING,
        # exports
        'FEEDS': {
            'glossary.json': {
                'format': 'json',
                'encoding': 'utf8',
                'fields': None,
                'indent': 4,
                'item_export_kwargs': {
                    'export_empty_fields': False
                }
            },
            'glossary.csv': {
                'format': 'csv',
                'encoding': 'utf8',
                'item_export_kwargs': {
                    'include_headers_line': True,
                    'delimiter': '#'
                }
            }
        }
    }

    start_urls = ['https://ec.europa.eu/eurostat/statistics-explained' +
                  '/index.php?title=Category:Glossary']

    def parse(self, response):
        # Gather the links on the page
        # starting with the start_urls link
        for page in response.css('#mw-pages').css('.mw-content-ltr'):
            for link in page.css('a ::attr(href)'):
                cptLink = 'https://ec.europa.eu' + link.extract()
                yield scrapy.Request(url=cptLink, callback=self.parse_concept)

        # Check if there is another page
        # if so re-launch the parse function
        # with nextPage url as start_urls
        nextPage = response.xpath("//a[contains(.//text(), 'next 200')]" +
                                  "/@href").get()
        if nextPage is not None:
            nextPage = response.urljoin('https://ec.europa.eu' + nextPage)
            yield scrapy.Request(nextPage, callback=self.parse)

    def parse_concept(self, response):

        # html page
        pageContent = BeautifulSoup(response.css('#mw-content-text').get(),
                                    'html.parser')

        # split around the part titles (ex: Related concepts , etc.)
        # list of strings (html)
        splitContent = re.split('<h2>|</h2>', pageContent.prettify())

        titleRaw = normalize(response.css('#firstHeading::text').get())
        definitionRaw = BeautifulSoup(splitContent[0], 'html.parser')
        redirected = response.xpath("//div[@id = 'contentSub']" +
                                    "[text()[contains(.,'Redirected')]]" +
                                    "/a/text()").get()

        concept = Concept()
        concept['url'] = response.request.url
        # check if already exists in DB
        cursor.execute(estatLinkSelectId(), concept['url'])
        c.commit()
        row = cursor.fetchone()
        if row is None:

            concept['title'] = titleRaw.replace('Glossary:', '')
            # check if there was a redirection
            if redirected is not None:
                concept['original_title'] = redirected.replace('Glossary:', '')

            if concept['title'] is None:
                concept['title'] = 'ERROR'

            cursor.execute(estatLinkInsert(), concept['title'], concept['url'])
            c.commit()
            # get id
            cursor.execute(estatLinkSelectId(), concept['url'])
            c.commit()
            row = cursor.fetchone()
            concept['id'] = row.id
        else:
            concept['id'] = row.id

        # last update
        updateStrRaw = response.xpath('//div[@id="footer"]' +
                                      '//li[@id="lastmod"]/text()').get()
        if updateStrRaw is not None:
            dateFormat = "%d %B %Y, at %H:%M."
            updateStr = re.split('modified on ', normalize(updateStrRaw))
            update = datetime.strptime(updateStr[-1], dateFormat)
            concept['last_update'] = update

        # check if already in DB
        cursor.execute(conceptSelect(), concept['id'])
        c.commit()
        row = cursor.fetchone()
        if row is None:

            concept['definition'] = normalize(definitionRaw.get_text())

            if updateStrRaw is not None:
                cursor.execute(conceptFullInsert(),
                               concept['id'], concept['definition'],
                               concept['last_update'])
            else:
                cursor.execute(conceptInsert(),
                               concept['id'], concept['definition'])
            c.commit()

            concept['further_info'] = []
            concept['related_concepts'] = []
            concept['statistical_data'] = []
            concept['sources'] = []

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
                        furtherInfo['title'] = normalize(elmt.get_text())
                        url = elmt.get('href')
                        if url.startswith('/eurostat'):
                            furtherInfo['url'] = 'https://ec.europa.eu' + url
                        else:
                            furtherInfo['url'] = url
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
                                               concept['id'], row.id)
                                c.commit()
                            else:
                                idLink = row.id
                                cursor.execute(furtherInfoCheck(),
                                               concept['id'], idLink)
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    # add link between the concept and the doc
                                    cursor.execute(furtherInfoInsert(),
                                                   concept['id'], idLink)

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
                                               concept['id'], row.id)
                                c.commit()
                            else:
                                idLink = row.id
                                cursor.execute(furtherInfoCheck(),
                                               concept['id'], idLink)
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    # add link between the concept and the doc
                                    cursor.execute(furtherInfoInsert(),
                                                   concept['id'], idLink)

                        concept['further_info'].append(furtherInfo)

                elif 'Related concepts' in titleTemp:
                    for elmt in BeautifulSoup(splitContent[a],
                                              'html.parser').find_all('a'):
                        relCpt = LinkInfo()
                        relCpt['title'] = normalize(elmt.get_text())
                        urlCpt = elmt.get('href')
                        relCpt['url'] = 'https://ec.europa.eu' + urlCpt
                        # check if the doc already is in the DB
                        cursor.execute(estatLinkSelectId(), relCpt['url'])
                        c.commit()
                        row = cursor.fetchone()

                        if row is None:
                            # add a document
                            cursor.execute(estatLinkInsert(),
                                           relCpt['title'], relCpt['url'])
                            c.commit()
                            # get id
                            cursor.execute(estatLinkSelectId(),
                                           relCpt['url'])
                            c.commit()
                            row = cursor.fetchone()
                            # add a link between the concept and the doc
                            cursor.execute(relCptInsert(),
                                           concept['id'], row.id)
                            c.commit()
                        else:
                            idLink = row.id
                            cursor.execute(relCptCheck(),
                                           concept['id'], idLink)
                            c.commit()
                            row = cursor.fetchone()
                            if row is None:
                                # add a link between the concept and the doc
                                cursor.execute(relCptInsert(),
                                               concept['id'], idLink)
                        concept['related_concepts'].append(relCpt)

                elif 'Statistical data' in titleTemp:
                    for elmt in BeautifulSoup(splitContent[a],
                                              'html.parser').find_all('a'):
                        statData = LinkInfo()
                        statData['title'] = elmt.get('title')
                        urlStat = elmt.get('href')
                        statData['url'] = 'https://ec.europa.eu' + urlStat
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
                                           statData['title'], statData['url'])
                            c.commit()
                            # get id
                            cursor.execute(estatLinkSelectId(),
                                           statData['url'])
                            c.commit()
                            row = cursor.fetchone()
                            # add a link between the concept and the doc
                            cursor.execute(statDataInsert(),
                                           concept['id'], row.id)
                            c.commit()
                        else:
                            idLink = row.id
                            cursor.execute(statDataCheck(),
                                           concept['id'], idLink)
                            c.commit()
                            row = cursor.fetchone()
                            if row is None:
                                # add link between the concept and the doc
                                cursor.execute(statDataInsert(),
                                               concept['id'], idLink)
                        concept['statistical_data'].append(statData)

                elif 'Source' in titleTemp:
                    for elmt in BeautifulSoup(splitContent[a],
                                              'html.parser').find_all('a'):
                        source = LinkInfo()
                        source['title'] = normalize(elmt.get_text())
                        url = elmt.get('href')
                        if url.startswith('/eurostat'):
                            source['url'] = 'https://ec.europa.eu' + url
                        else:
                            source['url'] = url
                        # select, check if in Link Info
                        if 'eurostat' in source['url']:
                            cursor.execute(estatLinkSelectId(),
                                           source['url'])
                            c.commit()
                            row = cursor.fetchone()

                            if row is None:
                                # add a document
                                cursor.execute(estatLinkInsert(),
                                               source['title'], source['url'])
                                c.commit()
                                # get id
                                cursor.execute(estatLinkSelectId(),
                                               source['url'])
                                c.commit()
                                row = cursor.fetchone()
                                # add a link between the concept and the doc
                                cursor.execute(sourceInsert(),
                                               concept['id'], row.id)
                                c.commit()
                            else:
                                idLink = row.id
                                cursor.execute(sourceCheck(),
                                               concept['id'], idLink)
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    # add link between the concept and the doc
                                    cursor.execute(sourceInsert(),
                                                   concept['id'], idLink)

                        else:
                            cursor.execute(foreignLinkSelectId(),
                                           source['url'])
                            c.commit()
                            row = cursor.fetchone()

                            if row is None:
                                # add a document
                                cursor.execute(foreignLinkInsert(),
                                               source['title'], source['url'])
                                c.commit()
                                # get id
                                cursor.execute(foreignLinkSelectId(),
                                               source['url'])
                                c.commit()
                                row = cursor.fetchone()
                                # add a link between the concept and the doc
                                cursor.execute(sourceInsert(),
                                               concept['id'], row.id)
                                c.commit()
                            else:
                                idLink = row.id
                                cursor.execute(sourceCheck(),
                                               concept['id'], idLink)
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    # add link between the concept and the doc
                                    cursor.execute(sourceInsert(),
                                                   concept['id'], idLink)
                        concept['sources'].append(source)

            categories = response.xpath('//div[@id="mw-normal-catlinks"]' +
                                        '/ul/li/a/text()').getall()

            concept['categories'] = categories
        # elif row.last_update == concept['last_update']:
            # To complete in order to update the DB

        yield concept
