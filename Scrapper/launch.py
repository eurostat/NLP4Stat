import scrapy
from scrapy.crawler import CrawlerProcess
from Spiders.glossary_spider import glossarySpider
from Spiders import article_spider

process = CrawlerProcess({
    'USER_AGENT': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)'
})

#process.crawl(articlesSpider)
process.crawl(glossarySpider)
process.start()