import scrapy
from scrapy.crawler import CrawlerProcess
#from Spiders.glossary_spider import glossarySpider
#from Spiders.glossary_redirection_spider import glossaryRedirectionSpider
from Spiders.article_spider import articlesSpider
#from Spiders.background_article_spider import backgroundArticlesSpider

process = CrawlerProcess({
    'USER_AGENT': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0'
})


#process.crawl(glossarySpider)
#process.crawl(glossaryRedirectionSpider)
process.crawl(articlesSpider)
#process.crawl(backgroundArticlesSpider)
process.start()