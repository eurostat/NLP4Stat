import scrapy
from scrapy.crawler import CrawlerProcess
from Spiders.glossary_spider import glossarySpider
#from Spiders.article_spider import articlesSpider

process = CrawlerProcess({
    'USER_AGENT': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0'
})

#process.crawl(articlesSpider)
process.crawl(glossarySpider)
process.start()