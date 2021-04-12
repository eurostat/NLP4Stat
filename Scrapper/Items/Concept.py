import scrapy

class Concept(scrapy.Item):
    id = scrapy.Field()
    url = scrapy.Field()
    title = scrapy.Field()
    definition = scrapy.Field()
    further_info = scrapy.Field()
    related_concepts = scrapy.Field()
    statistical_data = scrapy.Field()
    sources = scrapy.Field()
    categories = scrapy.Field()
    redirection = scrapy.Field()
    original_title = scrapy.Field()
    last_update = scrapy.Field()