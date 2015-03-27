<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:col="http://cnx.rice.edu/collxml"
  xmlns:c="http://cnx.rice.edu/cnxml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:md="http://cnx.rice.edu/mdml"
  xmlns:qml="http://cnx.rice.edu/qml/1.0"
  xmlns:mod="http://cnx.rice.edu/#moduleIds"
  xmlns:bib="http://bibtexml.sf.net/"
  xmlns:data="http://dev.w3.org/html5/spec/#custom"
  exclude-result-prefixes="xsl col c m md qml mod bib data"
  >

  <xsl:template match="col:metadata/md:title">
    <h1><xsl:value-of select="."/></h1>
  </xsl:template>

  <xsl:template match="col:metadata/md:actors">
    <p>
      <span class="editor"><xsl:value-of select="md:person[1]/md:fullname"/></span>
    </p>
    <p>
      <span class="authors"></span>
    </p>
  </xsl:template>

  <xsl:template match="col:metadata/md:content-url">
    <xsl:variable name="href">
      <xsl:value-of select="."/>
    </xsl:variable>
    <p>
      <span class="content-url">&lt;<a href="{$href}" rel="alternate"><xsl:value-of select="$href"/></a>&gt;</span>
    </p>
  </xsl:template>

  <xsl:template match="col:metadata/md:license">
  </xsl:template>

  <xsl:template match="col:metadata/md:revised">
  </xsl:template>

  <xsl:template match="col:metadata/md:abstract">
    <div data-type="abstract">
      <xsl:apply-templates select="node()|@*"/>
    </div>
  </xsl:template>

</xsl:stylesheet>
