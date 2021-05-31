import scrapy

class Paragraph(scrapy.Item):
    id = scrapy.Field()
    title = scrapy.Field()
    content = scrapy.Field()
    figures = scrapy.Field()
