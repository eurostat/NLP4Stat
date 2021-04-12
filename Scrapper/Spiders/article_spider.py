import scrapy
from scrapy.crawler import CrawlerProcess
from scrapy.crawler import Crawler
from scrapy.settings import Settings
from Items import LinkInfo
from Items import Concept
import generic_functions
from twisted.internet import reactor

from bs4 import BeautifulSoup

# buit in
import os 
import re
import logging
import sys
import pyodbc
import hashlib
import pandas as pd
from datetime import datetime

class articlesSpider(scrapy.Spider):
    name = 'articles'

    custom_settings = {
        # limit the logs
        'LOG_LEVEL': logging.WARNING,
        # exports
        'FEEDS': {
            'articles.json': {
                'format': 'json',
                'encoding': 'utf8',
                'fields': None,
                'indent': 4,
                'item_export_kwargs': {
                    'export_empty_fields': False
                }
            },
            'articles.csv': {
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
                  '/index.php?title=Category:Statistical_article']

    # go through all the articles
    def parse(self, response):
        # Gather the links on the page
        # starting with the start_urls link
        for page in response.css('#mw-pages').css('.mw-content-ltr'):
            for link in page.css('a ::attr(href)'):
                artLink = 'https://ec.europa.eu' + link.extract()
                yield scrapy.Request(url=artLink, callback=self.parse_article)

        # Check if there is another page
        # if so re-launch the parse function
        # with next_page url as start_urls
        nextPage = response.xpath("//a[contains(.//text(), 'next 200')]" +
                                   "/@href").get()
        if nextPage is not None:
            nextPage = response.urljoin('https://ec.europa.eu' + nextPage)
            yield scrapy.Request(nextPage, callback=self.parse)

    # get the information from one article
    def parse_article(self, response):

        article = Article()

        # abstract
        abstractRaw = response.xpath('//div[@class="col-lg-12 se-content"]' +
                                     '/p/descendant-or-self::*' +
                                     '/text()').getall()
        if len(abstractRaw) == 0:
            abstractRaw = response.xpath('//div[@id="mw-content-text"]' +
                                         '/p/descendant-or-self::*' +
                                         '/text()').getall()
            print('############################################')
            print(abstractRaw)
            print('############################################')
            
        if len(abstractRaw) == 0:
            print('*******************************************')
            print(BeautifulSoup(response.xpath('//div[@id="mw-content-text"]').get()))
            print(response.request.url)
            print('*********************************************')
            abstractRaw = response.xpath('//div[@class="col-lg-12 se-content"]' +
                                         'div/following-sibling::text()').getall()
            print(abstractRaw)
            
        abstract = ''
        for paragraph in abstractRaw:
            abstract = abstract + normalize(paragraph) + ' '

        if abstract == '' or abstract == ' ':
            print('la')
            print('----------------------------------------------------------------------')
            


        # full article
        fullArtRaw = response.xpath('//div[@class="panel-body-content"]' +
                                    '/div[@class="content-section"]').getall()
        fullArticle = []

        for seg in fullArtRaw:
            seg = BeautifulSoup(seg)
            articleParagraph = Paragraph()
            titles = seg.find_all('span', {'class': 'mw-headline'})

            if len(titles) > 0:

                titleTag = '<h2>|</h2>|<h3>|</h3>|<h4>|</h4>'
                splitContent = re.split(titleTag, seg.prettify())
                for i in range(len(titles)):
                    # title
                    title = titles[i].get_text()

                    text = BeautifulSoup(splitContent[2*i + 2])
                    # gather the text of each paragraph
                    contentRaw = text.find_all(['p', 'ul'])
                    content = ''
                    for part in contentRaw:
                        content = content + normalize(part.get_text()) + ' '

                    # figures
                    figures = text.find_all('div', {'class': 'thumbcaption'})

                    # assign the results to the right element
                    if title == 'Context':
                        article['context'] = content
                    elif title == 'Data Sources' or title == 'Data sources':
                        article['data_sources'] = content
                    else:
                        articleParagraph['title'] = title
                        articleParagraph['content'] = content

                        # figures
                        if (figures is not None) and (len(figures) != 0):
                            articleParagraph['figures'] = []
                            for fig in figures:
                                caption = re.split('<i>|</i>', fig.prettify())
                                figTemp = LinkInfo()

                                figTitle = BeautifulSoup(caption[0]).get_text()
                                figTemp['title'] = normalize(figTitle)

                                urls = BeautifulSoup(caption[-1]).find_all('a')
                                figTemp['url'] = []
                                for url in urls:
                                    figTemp['url'] = url.get('href')
                                    articleParagraph['figures'].append(figTemp)

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
                article['context'] = ctxt

            # data sources
            if 'data_sources' not in article:
                dataSourcesRaw = response.xpath('//div[@id="data-details"]' +
                                                '/p/descendant-or-self::*' +
                                                '/text()').getall()
                dataSources = ''
                for part in dataSourcesRaw:
                    dataSources = dataSources + normalize(part) + ' '
                article['data_sources'] = dataSources

            # excel
            excelRaw = response.xpath('//div[@id="content-excel"]').get()
            if excelRaw is not None:
                excelTab = BeautifulSoup(excelRaw).find_all('a')
                article['excel'] = []
                for a in excelTab:
                    linkTemp = LinkInfo()
                    linkTemp['title'] = a.get('title')
                    linkTemp['url'] = a.get('href')
                    article['excel'].append(linkTemp)
        # alerts
        alertsRaw = response.xpath('//div[@class="content"]' +
                                   '//div[@class="alert alert-th3"]').getall()
        if alertsRaw is not None:
            alerts = []
            for alertRaw in alertsRaw:
                alertTab = BeautifulSoup(alertRaw).find_all('p')
                alertTemp = Paragraph()
                alertTemp['title'] = normalize(alertTab[0].get_text())
                alertTxt = ''
                for p in alertTab[1:]:
                    alertTxt = alertTxt + normalize(p.get_text()) + ' '
                alertTemp['content'] = alertTxt

                alerts.append(alertTemp)

        categories = response.xpath('//div[@id="mw-normal-catlinks"]' +
                                    '/ul/li/a/text()').getall()

        article['url'] = response.request.url
        article['title'] = normalize(response.css('#firstHeading::text').get())
        article['abstract'] = normalize(abstract)
        article['full_article'] = fullArticle
        article['alerts'] = alerts
        article['categories'] = categories
        
        # last update
        updateStrRaw = response.xpath('//div[@id="footer"]' +
                                      '//li[@id="lastmod"]/text()').get()
        if updateStrRaw is not None:
            dateFormat = "%d %B %Y, at %H:%M."
            updateStr = re.split('modified on ', normalize(updateStrRaw))
            update = datetime.strptime(updateStr[-1], dateFormat)
            article['last_update'] = update

        # direct access
        directAccess = response.xpath('//div[@class="dat-section"]').getall()

        for elmnt in directAccess:
            elmntBs = BeautifulSoup(elmnt)
            tabLinks = elmntBs.find_all('a')
            linkslist = []
            for a in tabLinks:
                linkTemp = LinkInfo()
                linkTemp['title'] = normalize(a.get_text())
                linkTemp['url'] = a.get('href')
                linkslist.append(linkTemp)

            sectionTitle = elmntBs.find('div').get('id')

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

        # add record to pd dataframe
        pos = len(articlesDf)
        keys = list(article.keys())
        for key in keys:
            articlesDf.loc[pos, key] = article[key]

        yield article