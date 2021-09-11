import scrapy

class News(scrapy.Item):
    id = scrapy.Field()
    url = scrapy.Field()
    title = scrapy.Field()
    publication_date = scrapy.Field()
    body = scrapy.Field()