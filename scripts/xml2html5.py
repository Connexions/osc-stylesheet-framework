import sys, os
from lxml import etree
from utils import *

def generate_toc(collxml_tree):
  """
    Takes a collxml xml tree which has already generated xinclude links for modules
    and generates a book-level TOC which cross references modules.
  """
  xslt = makeXsl('collxml-toc.xsl')
  xhtml = xslt(collxml_tree)
  return xhtml

def transform_collxml(collxml_file):
  """ Given a collxml file (collection.xml) this returns an HTML version of it
      (including "include" anchor links to the modules) """

  xml = etree.parse(collxml_file)
  xslt = makeXsl('collxml-to-html5.xsl')
  xhtml = xslt(xml)
  xhtml = generate_toc(xhtml)

  return xhtml

def transform_cnxml(cnxml_file):
  """ Given a cnxml file (index.cnxml or index_auto_generated.cnxml) this returns an HTML
      version of it.
  """
  return None

def transform_collection(collection_dir):
  """ Given an unzipped collection generate a giant HTML file representing
      the entire collection (including loading and converting individual modules) """

  collxml_file_path = os.path.join(collection_dir, 'collection.xml')
  if not os.path.exists(collxml_file_path):
    print collection_dir + ' is not an unzipped complete collection.'
    print collxml_file_path + ' was not found.'
    sys.exit(2)
  collxml_file = open(collxml_file_path)
  collxml_html = transform_collxml(collxml_file)

  return collxml_html

if __name__ == '__main__':
  try:
    import argparse
  except ImportError:
    print "Argparse is required, and missing. Try easy_install argparse, pip install argparse, etc."
    sys.exit(2)

  parser = argparse.ArgumentParser(description='Convert a CNXML Collection to HTML5')
  parser.add_argument('collection_directory', help='The unzipped complete collection directory to convert to a single HTML5 document.')
  parser.add_argument('html_file', help='/path/to/output.html', nargs='?', type=argparse.FileType('w'), default=sys.stdout)
  parser.add_argument('--no-tidy', dest='tidy', action='store_false')
  parser.add_argument('--tidy', dest='tidy', action='store_true')
  parser.set_defaults(tidy=True)
  args = parser.parse_args()

  html = transform_collection(args.collection_directory)

  if (args.tidy):
    args.html_file.write(tidy_html(etree.tostring(html)))
  else:
    args.html_file.write(etree.tostring(html))
