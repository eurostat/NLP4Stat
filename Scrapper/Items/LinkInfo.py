
import scrapy

class LinkInfo(scrapy.Item):
    title = scrapy.Field()
    url = scrapy.Field()