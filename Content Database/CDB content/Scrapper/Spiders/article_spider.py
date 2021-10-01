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
from Items.Article import Article
from Items.Paragraph import Paragraph
from sql_request import *

c = pyodbc.connect('DSN=nlp4stat;' +
                   'DBA=ESTAT;' +
                   'UID=dba;' +
                   'PWD=dba')
cursor = c.cursor()

class articlesSpider(scrapy.Spider):
    name = 'articles'

    custom_settings = {
        # limit the logs
        'LOG_LEVEL': logging.WARNING,
        'DOWNLOAD_DELAY': 1
    }

    start_urls = ['https://ec.europa.eu/eurostat/statistics-explained' +
                  '/index.php?title=Category:Statistical_article']

    # go through all the articles
    def parse(self, response):
        # Gather the links on the page
        # starting with the start_urls link
        for page in response.css('#mw-pages').css('.mw-content-ltr'):
            for link in page.css('a ::attr(href)'):
                artLink = 'https://ec.europa.eu' + link.extract()
                time.sleep(2)
                yield scrapy.Request(url=artLink, callback=self.parse_article)

        # Check if there is another page
        # if so re-launch the parse function
        # with next_page url as start_urls
        nextPage = response.xpath("//a[contains(.//text(), 'next page')]" +
                                   "/@href").get()
        if nextPage is not None:
            nextPage = response.urljoin('https://ec.europa.eu' + nextPage)
            yield scrapy.Request(nextPage, callback=self.parse)

    # get the information from one article
    def parse_article(self, response):

        article = Article()

        article['url'] = response.request.url
        # check if already exists in DB
        cursor.execute(estatLinkSelectId(), article['url'])
        c.commit()
        row = cursor.fetchone()
        # if it does not exist
        if row is None:
            titleRaw = response.css('#firstHeading::text').get()
            if titleRaw is not None:
                titleRaw = normalize(titleRaw)
                article['title'] = titleRaw.encode('utf-8')

            else:
                article['title'] = 'ERROR'

            cursor.execute(estatLinkTypeKnownInsert(),
                           article['title'],
                           article['url'],
                           52)
            c.commit()
            # get id
            cursor.execute(estatLinkSelectId(),
                           article['url'])
            c.commit()
            row = cursor.fetchone()
            article['id'] = row.id
        else:
            article['id'] = row.id
            cursor.execute(LinkTypeUpdate(),
                           52,
                           row.id)

        # last update
        updateStrRaw = response.xpath('//div[@id="footer"]' +
                                      '//li[@id="footer-info-lastmod"]/text()').get()
        if updateStrRaw is not None:
            dateFormat = "%d %B %Y, at %H:%M."
            updateStr = re.split('edited on ', normalize(updateStrRaw))
            update = datetime.strptime(updateStr[-1], dateFormat)
            article['last_update'] = update

        # check if already in DB
        cursor.execute(articleSelect(), article['id'])
        c.commit()
        row = cursor.fetchone()
        if row is None:

            if updateStrRaw is not None:
                cursor.execute(articleFullInsert(),
                               article['id'],
                               article['last_update'])
            else:
                cursor.execute(articleInsert(),
                               article['id'])
            c.commit()

            # full article
            fullArtRaw = response.xpath('//div[@class="panel-body-content"]' +
                                        '/div[@class="content-section"]').getall()
            fullArticle = []

            for seg in fullArtRaw:
                seg = BeautifulSoup(seg, 'html.parser')
                articleParagraph = Paragraph()
                titles = seg.find_all('span', {'class': 'mw-headline'})

                if len(titles) > 0:

                    titleTag = '<h2>|</h2>|<h3>|</h3>|<h4>|</h4>'
                    splitContent = re.split(titleTag, seg.prettify())
                    for i in range(len(titles)):
                        # title
                        title = normalize(titles[i].get_text())

                        text = BeautifulSoup(splitContent[2*i + 2], 'html.parser')
                        # gather the text of each paragraph
                        contentRaw = text.find_all(['p', 'ul'])
                        content = ''
                        for part in contentRaw:
                            content = content + normalize(part.get_text()) + ' '

                        # figures
                        figures = text.find_all('div', {'class': 'thumbcaption'})

                        # assign the results to the right element
                        if title == 'Context':
                            article['context'] = content.encode('utf-8')
                        elif title == 'Data Sources' or title == 'Data sources':
                            article['data_sources'] = content.encode('utf-8')
                        else:
                            articleParagraph['title'] = title.encode('utf-8')
                            articleParagraph['content'] = content.encode('utf-8')

                            cursor.execute(paragraphInsert(),
                                           article['id'],
                                           articleParagraph['title'],
                                           articleParagraph['content'])
                            c.commit()

                            # getting the paragraph id
                            cursor.execute(paragraphSelect(),
                                           article['id'],
                                           articleParagraph['title'])
                            c.commit()
                            row = cursor.fetchone()
                            articleParagraph['id'] = row.id

                            # figures
                            if (figures is not None) and (len(figures) != 0):
                                articleParagraph['figures'] = []
                                for fig in figures:
                                    caption = re.split('<i>|</i>', fig.prettify())
                                    figTemp = LinkInfo()

                                    figTitle = BeautifulSoup(caption[0], 'html.parser').get_text()
                                    figTemp['title'] = normalize(figTitle).encode('utf-8')

                                    urls = BeautifulSoup(caption[-1], 'html.parser').find_all('a')
                                    figTemp['url'] = []
                                    for url in urls:
                                        # cleaning the url
                                        url = url.get('href')
                                        if "oldid" not in url:
                                            urlClean = url
                                        else:
                                            urlClean = re.split('&oldid', url)[0]

                                        if urlClean.startswith('/eurostat'):
                                            figTemp['url'] = 'https://ec.europa.eu' + urlClean
                                        else:
                                            figTemp['url'] = urlClean
                                        articleParagraph['figures'].append(figTemp)
                                        if 'eurostat' in figTemp['url']:
                                            # check if already exist in LinkInfo
                                            cursor.execute(estatLinkSelectId(),
                                            figTemp['url'])
                                            c.commit()
                                            row = cursor.fetchone()
                                            if row is None:
                                                cursor.execute(estatLinkInsert(),
                                                               figTemp['title'],
                                                               figTemp['url'])
                                                c.commit()
                                                # get id
                                                cursor.execute(estatLinkSelectId(),
                                                               figTemp['url'])
                                                c.commit()
                                                row = cursor.fetchone()
                                                # add a link between the figure and the paragraph
                                                cursor.execute(figureInsert(),
                                                               articleParagraph['id'], row.id)
                                                c.commit()
                                            else:
                                                idLink = row.id
                                                cursor.execute(figureCheck(),
                                                               articleParagraph['id'], idLink)
                                                c.commit()
                                                row = cursor.fetchone()
                                                if row is None:
                                                    # add link between the concept and the doc
                                                    cursor.execute(figureInsert(),
                                                                   articleParagraph['id'], idLink)
                                        else:
                                            # check if already exist in LinkInfo
                                            cursor.execute(foreignLinkSelectId(),
                                            figTemp['url'])
                                            c.commit()
                                            row = cursor.fetchone()
                                            if row is None:
                                                cursor.execute(foreignLinkInsert(),
                                                               figTemp['title'],
                                                               figTemp['url'])
                                                c.commit()
                                                # get id
                                                cursor.execute(foreignLinkSelectId(),
                                                               figTemp['url'])
                                                c.commit()
                                                row = cursor.fetchone()
                                                # add a link between the figure and the paragraph
                                                cursor.execute(figureInsert(),
                                                               articleParagraph['id'], row.id)
                                                c.commit()
                                            else:
                                                idLink = row.id
                                                cursor.execute(figureCheck(),
                                                               articleParagraph['id'], idLink)
                                                c.commit()
                                                row = cursor.fetchone()
                                                if row is None:
                                                    # add link between the concept and the doc
                                                    cursor.execute(figureInsert(),
                                                                   articleParagraph['id'], idLink)
                        
                        # if it's a paragraph from the article
                        if 'title' in articleParagraph:
                            fullArticle.append(articleParagraph)

                # context
                if 'context' not in article:
                    contextRaw = response.xpath('//div[@id="content-context"]' +
                                                '/p/descendant-or-self::*' +
                                                '/text()').getall()
                    ctxt = ''
                    for part in contextRaw:
                        ctxt = ctxt + normalize(part) + ' '
                    article['context'] = ctxt.encode('utf-8')

                # data sources
                if 'data_sources' not in article:
                    dataSourcesRaw = response.xpath('//div[@id="data-details"]' +
                                                    '/p/descendant-or-self::*' +
                                                    '/text()').getall()
                    dataSources = ''
                for part in dataSourcesRaw:
                    dataSources = dataSources + normalize(part) + ' '
                
                article['data_sources'] = dataSources.encode('utf-8')

                cursor.execute(articleFillExisting(),
                               article['context'],
                               article['data_sources'],
                               article['id'])

                c.commit()

                # excel
                excelRaw = response.xpath('//div[@id="content-excel"]').get()
                if excelRaw is not None:
                    excelTab = BeautifulSoup(excelRaw, 'html.parser').find_all('a')
                    article['excel'] = []
                    for a in excelTab:
                        linkTemp = LinkInfo()
                        linkTemp['title'] = a.get('title')
                        linkTemp['url'] = a.get('href')
                        if linkTemp['title'] is None:
                            linkTemp['title'] = linkTemp['url']
                        article['excel'].append(linkTemp)

                        if linkTemp['url'] is not None:
                            if "oldid" in linkTemp['url']:
                                linkTemp['url'] = re.split('&oldid', linkTemp['url'])[0]

                            if linkTemp['url'].startswith('/eurostat'):
                                linkTemp['url'] = 'https://ec.europa.eu' + linkTemp['url']
                            
                            if 'eurostat' in linkTemp['url']:
                                # check if already exist in LinkInfo
                                cursor.execute(estatLinkSelectId(),
                                                linkTemp['url'])
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    cursor.execute(estatLinkInsert(),
                                                    linkTemp['title'],
                                                    linkTemp['url'])
                                    c.commit()
                                    # get id
                                    cursor.execute(estatLinkSelectId(),
                                                    linkTemp['url'])
                                    c.commit()
                                    row = cursor.fetchone()
                                    # add a link between the shared link and the article
                                    cursor.execute(sharedLinkInsert(),
                                                    article['id'],
                                                    row.id,
                                                    1)
                                    c.commit()
                                else:
                                    idLink = row.id
                                    cursor.execute(sharedLinkCheck(),
                                                    article['id'],
                                                    idLink,
                                                    1)
                                    c.commit()
                                    row = cursor.fetchone()
                                    if row is None:
                                        # add a link between the shared link and the article
                                        cursor.execute(sharedLinkInsert(),
                                                        article['id'],
                                                        idLink,
                                                        1)
                            else:
                                # check if already exist in LinkInfo
                                cursor.execute(foreignLinkSelectId(),
                                                linkTemp['url'])
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    cursor.execute(foreignLinkInsert(),
                                                    linkTemp['title'],
                                                    linkTemp['url'])
                                    c.commit()
                                    # get id
                                    cursor.execute(foreignLinkSelectId(),
                                                    linkTemp['url'])
                                    c.commit()
                                    row = cursor.fetchone()
                                    # add a link between the shared link and the article
                                    cursor.execute(sharedLinkInsert(),
                                                    article['id'],
                                                    row.id,
                                                    1)
                                    c.commit()
                                else:
                                    idLink = row.id
                                    cursor.execute(sharedLinkCheck(),
                                                    article['id'],
                                                    idLink,
                                                    1)
                                    c.commit()
                                    row = cursor.fetchone()
                                    if row is None:
                                        # add a link between the shared link and the article
                                        cursor.execute(sharedLinkInsert(),
                                                        article['id'],
                                                        idLink,
                                                        1)


            article['full_article'] = fullArticle
            
            # abstract
            abstractRaw = response.xpath('//div[@class="col-lg-12 se-content"]' +
                                         '/p/descendant-or-self::*' +
                                         '/text()').getall()
            if len(abstractRaw) == 0:
                abstractRaw = response.xpath('//div[@id="mw-content-text"]' +
                                             '/p/descendant-or-self::*' +
                                             '/text()').getall()
            
            if len(abstractRaw) == 0:
                abstractRaw = response.xpath('//div[@class="col-lg-12 se-content"]' +
                                             'div/following-sibling::text()').getall()

            if len(abstractRaw) == 0:
                abstractRaw = response.xpath('//div[@class="se-highlight"]' +
                                             '//p/descendant-or-self::*' +
                                             '/text()').getall()
            
            
            abstract = ''
            for paragraph in abstractRaw:
                abstract = abstract + normalize(paragraph) + ' '

            if abstract == '' or abstract == ' ':
                print('la')
                print('----------------------------------------------------------------------')                

            
            article['abstract'] = normalize(abstract).encode('utf-8')
            cursor.execute(abstractInsert(),
                           article['id'],
                           'Abstract',
                           article['abstract'])

            c.commit()

            #getting abstract id
            cursor.execute(paragraphSelect(),
                           article['id'],
                           'Abstract')
            c.commit()
            row = cursor.fetchone()
            abstractId = row.id

            # abstract figures
            figureAbstract = response.xpath('//div[@class="se-highlight"]' +
                                            '//div[@class="thumbcaption"]' +
                                            '/text()').get()

            if figureAbstract is not None:
                caption = re.split('<i>|</i>', figureAbstract)
                figTemp = LinkInfo()

                figTitle = BeautifulSoup(caption[0], 'html.parser').get_text()
                figTemp['title'] = normalize(figTitle).encode('utf-8')

                urls = BeautifulSoup(caption[-1], 'html.parser').find_all('a')
                figTemp['url'] = []
                for url in urls:
                    # cleaning the url
                    url = url.get('href')
                    if "oldid" not in url:
                        urlClean = url
                    else:
                        urlClean = re.split('&oldid', url)[0]

                    if urlClean.startswith('/eurostat'):
                        figTemp['url'] = 'https://ec.europa.eu' + urlClean
                    else:
                        figTemp['url'] = urlClean
                    
                    if 'eurostat' in figTemp['url']:
                        # check if already exist in LinkInfo
                        cursor.execute(estatLinkSelectId(),
                        figTemp['url'])
                        c.commit()
                        row = cursor.fetchone()
                        if row is None:
                            cursor.execute(estatLinkInsert(),
                                           figTemp['title'],
                                           figTemp['url'])
                            c.commit()
                            # get id
                            cursor.execute(estatLinkSelectId(),
                                           figTemp['url'])
                            c.commit()
                            row = cursor.fetchone()
                            # add a link between the figure and the paragraph
                            cursor.execute(figureInsert(),
                                           abstractId, row.id)
                            c.commit()
                        else:
                            idLink = row.id
                            cursor.execute(figureCheck(),
                                           abstractId, idLink)
                            c.commit()
                            row = cursor.fetchone()
                            if row is None:
                                # add link between the concept and the doc
                                cursor.execute(figureInsert(),
                                               abstractId, idLink)
                    else:
                        # check if already exist in LinkInfo
                        cursor.execute(foreignLinkSelectId(),
                        figTemp['url'])
                        c.commit()
                        row = cursor.fetchone()
                        if row is None:
                            cursor.execute(foreignLinkInsert(),
                                           figTemp['title'],
                                           figTemp['url'])
                            c.commit()
                            # get id
                            cursor.execute(foreignLinkSelectId(),
                                            figTemp['url'])
                            c.commit()
                            row = cursor.fetchone()
                            # add a link between the figure and the paragraph
                            cursor.execute(figureInsert(),
                                           abstractId, row.id)
                            c.commit()
                        else:
                            idLink = row.id
                            cursor.execute(figureCheck(),
                                           abstractId, idLink)
                            c.commit()
                            row = cursor.fetchone()
                            if row is None:
                                # add link between the concept and the doc
                                cursor.execute(figureInsert(),
                                               abstractId, idLink)


            # alerts
            alertsRaw = response.xpath('//div[@class="content"]' +
                                       '//div[@class="alert alert-th3"]').getall()
            if alertsRaw is not None:
                alerts = []
                for alertRaw in alertsRaw:
                    alertTab = BeautifulSoup(alertRaw, 'html.parser').find_all('p')
                    alertTemp = Paragraph()
                    alertTemp['title'] = normalize(alertTab[0].get_text()).encode('utf-8')
                    alertTxt = ''
                    for p in alertTab[1:]:
                        alertTxt = alertTxt + normalize(p.get_text()) + ' '
                    alertTemp['content'] = alertTxt.encode('utf-8')
                    cursor.execute(alertInsert(),
                                   article['id'],
                                   alertTemp['title'],
                                   alertTemp['content'])
                    c.commit()

                    alerts.append(alertTemp)
            article['alerts'] = alerts

            # categories
            categories = response.xpath('//div[@id="mw-normal-catlinks"]' +
                                        '/ul/li/a/text()').getall()
            
            article['categories'] = categories

            # direct access
            directAccess = response.xpath('//div[@class="dat-section"]').getall()

            for elmnt in directAccess:
                elmntBs = BeautifulSoup(elmnt, 'html.parser')
                tabLinks = elmntBs.find_all('a')
                sectionTitle = elmntBs.find('div').get('id')
                division = 0
                if sectionTitle == 'seealso':
                    division = 2
                elif sectionTitle == 'maintables':
                    division = 3
                elif sectionTitle == 'database':
                    division = 4
                elif sectionTitle == 'dedicatedsection':
                    division = 5
                elif sectionTitle == 'publications':
                    division = 6
                elif sectionTitle == 'methodology':
                    division = 7
                elif sectionTitle == 'legal':
                    division = 8
                elif sectionTitle == 'visualisation':
                    division = 9
                elif sectionTitle == 'externallinks':
                    division = 10
                linkslist = []
                for a in tabLinks:
                    linkTemp = LinkInfo()
                    linkTemp['title'] = normalize(a.get_text())
                    urlLinkTemp = a.get('href')
                    if urlLinkTemp is not None:
                        if "oldid" not in urlLinkTemp:
                            urlLinkClean = urlLinkTemp
                        else:
                            urlLinkClean = re.split('&oldid', urlLinkTemp)[0]

                        if urlLinkClean.startswith('/eurostat'):
                            linkTemp['url'] = 'https://ec.europa.eu' + urlLinkClean
                        else:
                            linkTemp['url'] = urlLinkClean
                        linkslist.append(linkTemp)
                        if linkTemp['url'] is not None:
                            if 'eurostat' in linkTemp['url']:
                                # check if already exist in LinkInfo
                                cursor.execute(estatLinkSelectId(),
                                               linkTemp['url'])
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    cursor.execute(estatLinkInsert(),
                                                   linkTemp['title'],
                                                   linkTemp['url'])
                                    c.commit()
                                    # get id
                                    cursor.execute(estatLinkSelectId(),
                                                   linkTemp['url'])
                                    c.commit()
                                    row = cursor.fetchone()
                                    # add a link between the shared link and the article
                                    cursor.execute(sharedLinkInsert(),
                                                   article['id'],
                                                   row.id,
                                                   division)
                                    c.commit()
                                else:
                                    idLink = row.id
                                    cursor.execute(sharedLinkCheck(),
                                                   article['id'],
                                                   idLink,
                                                   division)
                                    c.commit()
                                    row = cursor.fetchone()
                                    if row is None:
                                        # add a link between the shared link and the article
                                        cursor.execute(sharedLinkInsert(),
                                                       article['id'],
                                                       idLink,
                                                       division)
                            else:
                                # check if already exist in LinkInfo
                                cursor.execute(foreignLinkSelectId(),
                                                linkTemp['url'])
                                c.commit()
                                row = cursor.fetchone()
                                if row is None:
                                    cursor.execute(foreignLinkInsert(),
                                                    linkTemp['title'],
                                                    linkTemp['url'])
                                    c.commit()
                                    # get id
                                    cursor.execute(foreignLinkSelectId(),
                                                    linkTemp['url'])
                                    c.commit()
                                    row = cursor.fetchone()
                                    # add a link between the shared link and the article
                                    cursor.execute(sharedLinkInsert(),
                                                    article['id'],
                                                    row.id,
                                                    division)
                                    c.commit()
                                else:
                                    idLink = row.id
                                    cursor.execute(sharedLinkCheck(),
                                                    article['id'],
                                                    idLink,
                                                    division)
                                    c.commit()
                                    row = cursor.fetchone()
                                    if row is None:
                                        # add a link between the shared link and the article
                                        cursor.execute(sharedLinkInsert(),
                                                        article['id'],
                                                        idLink,
                                                        division)



                if sectionTitle == 'seealso':
                    article['other_articles'] = linkslist
                elif sectionTitle == 'maintables':
                    article['tables'] = linkslist
                elif sectionTitle == 'database':
                    article['database'] = linkslist
                elif sectionTitle == 'dedicatedsection':
                    article['dedicated_section'] = linkslist
                elif sectionTitle == 'publications':
                    article['publications'] = linkslist
                elif sectionTitle == 'methodology':
                    article['methodology'] = linkslist
                elif sectionTitle == 'legal':
                    article['legislation'] = linkslist
                elif sectionTitle == 'visualisation':
                    article['visualisations'] = linkslist
                elif sectionTitle == 'externallinks':
                    article['external_links'] = linkslist

        # elif row.last_update == concept['last_update']:
            # To complete in order to update the DB

        yield article
