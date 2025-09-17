from xml.etree.ElementTree import Element, SubElement, tostring


class RSSGenerator:
    def __init__(self, title: str, link: str, description: str) -> None:
        self.title = title
        self.link = link
        self.description = description

    def create_feed(self) -> bytes:
        rss = Element("rss", version="2.0")
        channel = SubElement(rss, "channel")
        SubElement(channel, "title").text = self.title
        SubElement(channel, "link").text = self.link
        SubElement(channel, "description").text = self.description
        return tostring(rss, encoding="utf-8")

    def add_item(self, feed_xml: bytes, title: str, url: str) -> bytes:
        # TODO: Parse feed_xml and append item; for now, return input
        return feed_xml
