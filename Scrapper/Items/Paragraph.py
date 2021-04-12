import scrapy

class Paragraph(scrapy.Item):
    title = scrapy.Field()
    content = scrapy.Field()
    figures = scrapy.Field()
