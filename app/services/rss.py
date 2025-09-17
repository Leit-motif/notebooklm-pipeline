from xml.etree.ElementTree import Element, SubElement, tostring, fromstring


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
        root = fromstring(feed_xml)
        channel = root.find("channel")
        if channel is None:
            channel = SubElement(root, "channel")
        item = SubElement(channel, "item")
        SubElement(item, "title").text = title
        SubElement(item, "enclosure", url=url, type="audio/mpeg")
        SubElement(item, "link").text = url
        return tostring(root, encoding="utf-8")
