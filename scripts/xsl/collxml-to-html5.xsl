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
  <xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" omit-xml-declaration="yes" />

  <xsl:include href="utils.xsl"/>
  <xsl:include href="cnxml-to-html5.xsl"/>

  <!-- Begin processing with the collection node -->
  <xsl:template match="col:collection">
    <html>
      <head>
        <title><xsl:value-of select="col:metadata/md:title"/></title>
      </head>
      <body data-type="book">
        <div class="front-matter">
          <header data-type="titlepage">
            <xsl:apply-templates select="col:metadata/md:title"/>
            <xsl:apply-templates select="col:metadata/md:actors"/>
            <xsl:apply-templates select="col:metadata/md:content-url"/>
            <xsl:apply-templates select="col:metadata/md:license"/>
            <xsl:apply-templates select="col:metadata/md:revised"/>
          </header>
          <nav class="contents">
            <xsl:call-template name="prevent.self.closure"/>
          </nav>
          <div class="foreword">
            <xsl:apply-templates select="col:metadata/md:abstract"/>
          </div>
        </div>
        <div class="body-matter">
          <xsl:apply-templates select="col:content/node()"/>
        </div>
        <div class="back-matter">
          <section data-type="colophon">
            <xsl:call-template name="prevent.self.closure"/>
          </section>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- Units are subcollections which contain subcollections -->
  <xsl:template match="col:subcollection[col:content/col:subcollection]">
    <section data-type="unit" id="{generate-id(.)}">
      <xsl:apply-templates select="node()|@*"/>
    </section>
  </xsl:template>

  <!-- Chapters are subcollections which do not contain subcollections -->
  <xsl:template match="col:subcollection[not(col:content/col:subcollection)]">
    <section data-type="chapter" id="{generate-id(.)}">
      <xsl:apply-templates select="node()|@*"/>
    </section>
  </xsl:template>

  <!-- Chapters in Units are subcollections that are inside a subcollection -->
  <xsl:template match="col:subcollection/col:content/col:subcollection[not(col:content/col:subcollection)]">
    <section data-type="chapter" id="{generate-id(.)}">
      <xsl:apply-templates select="node()|@*"/>
    </section>
  </xsl:template>

  <!-- Preface modules come before any subcollections -->
  <xsl:template match="col:content[col:subcollection and col:module]/col:module[not(preceding-sibling::col:subcollection)]">
    <section data-type="preface" id="{generate-id(.)}">
      <xsl:apply-templates select="node()"/>
      <xsl:call-template name="cnx.xinclude.module"/>
    </section>
  </xsl:template>

  <!-- Appendix modules come after subcollections -->
  <xsl:template match="col:content[col:subcollection and col:module]/col:module[not(following-sibling::col:subcollection)]">
    <section data-type="appendix" id="{generate-id(.)}">
      <xsl:apply-templates select="node()"/>
      <xsl:call-template name="cnx.xinclude.module"/>
    </section>
  </xsl:template>

  <xsl:template match="col:module">
    <section data-type="module" id="{generate-id(.)}">
      <xsl:apply-templates select="node()"/>
      <xsl:call-template name="cnx.xinclude.module"/>
    </section>
  </xsl:template>

  <xsl:template match="md:title">
    <h1><xsl:apply-templates select="node()"/></h1>
  </xsl:template>

  <!-- Stub for included modules which gets replaced with the
       module's xml tree in a second pass of the collection tree. -->
  <xsl:template name="cnx.xinclude.module">
    <a class="xinclude" href="{@document}.html"><xsl:value-of select="md:title/text()"/></a>
  </xsl:template>
</xsl:stylesheet>
