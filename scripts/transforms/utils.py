import pkg_resources
from lxml import etree
from tidylib import tidy_document

def tidy_html(html):
    if hasattr(html, 'read'):
        html = html.read()
    html5, errors = tidy_document(html, options={
        'merge-divs': 0,       # do not merge nested div elements - preserve semantic block structures
        'output-xml': 0,
        'indent': 1,
        'tidy-mark': 0,
        'wrap': 0,
        'alt-text': '',
        'doctype': 'html5',
        'markup': 1
    })
    return html5

def makeXsl(filename):
  """ Helper that creates a XSLT stylesheet """

  path = pkg_resources.resource_filename('xsl' , filename)
  xml = etree.parse(path)
  return etree.XSLT(xml)
