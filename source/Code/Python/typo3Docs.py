import scrapy


class TYPO3VersionSpider(scrapy.Spider):
    name = 'typo3versionspider'
    start_urls = [
        'https://docs.typo3.org/typo3cms/extensions/core/',
        'https://docs.typo3.org/typo3cms/extensions/core/latest/',
    ]

    def parse(self, response):
        for href in response.css('#old-changes a.reference.internal::attr(href)'):
            full_url = response.urljoin(href.extract())
            yield scrapy.Request(full_url, callback=self.parse_version)

    def parse_version(self, response):
        yield {
            'version': response.css('h1::text').extract()[:3],
            'changes': {
                'breaking': len(response.css('#breaking-changes a.reference.internal::text').extract()),
                'deprecation': len(response.css('#deprecation a.reference.internal::text').extract()),
                'feature': len(response.css('#features a.reference.internal::text').extract()),
                'important': len(response.css('#important a.reference.internal::text').extract()),
            }
        }
