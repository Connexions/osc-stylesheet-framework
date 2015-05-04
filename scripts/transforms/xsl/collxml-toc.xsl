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

  <xsl:template match="/html/body/div[@class='front-matter']/nav[@class='contents']">
    <nav class="contents">
      <xsl:variable name="toc-class" >
      <xsl:choose>
        <xsl:when test="/html/body/div[@class='body-matter']/section[@data-type='unit']">
          <xsl:value-of select="'toc-unit'" />
        </xsl:when>
        <xsl:when test="/html/body/div[@class='body-matter']/section[@data-type='chapter']">
          <xsl:value-of select="'toc-chapter'" />
        </xsl:when>
          <xsl:otherwise>
          <xsl:value-of select="'toc-module'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <ul class="{$toc-class}">
      <xsl:for-each select="/html/body/div[@class='body-matter']/section">
       <li> <xsl:call-template name="toc-section" /></li>
      </xsl:for-each>
    </ul>
    </nav>
  </xsl:template>

  <!-- Section elements in body matter could be units, chapters, or modules. -->
  <xsl:template name="toc-section">
    <xsl:choose>
      <xsl:when test="@data-type='unit'">
        <xsl:call-template name="toc-unit" />
      </xsl:when>
      <xsl:when test="@data-type='chapter'">
        <xsl:call-template name="toc-chapter" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="toc-module" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- For units keep parsing any sections (chapters or modules) below it. -->
  <xsl:template name="toc-unit">
      <span class="label"><xsl:text> </xsl:text></span>
      <span class="number"><xsl:text> </xsl:text></span>
      <span class="divider"><xsl:text> </xsl:text></span>
      <span class="wording"><a href="#{@id}" class="toc-unit"><xsl:value-of select="./h1" /></a></span>
    <ul class="toc-chapter">
      <xsl:for-each select="./section">
        <li>
          <xsl:call-template name="toc-section" />
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- For chapters keep parsing any sections (modules) below it. -->
  <xsl:template name="toc-chapter">
      <a href="#{@id}" class="toc-chapter">
      <span class="label"><xsl:text> </xsl:text></span>
      <span class="number"><xsl:text> </xsl:text></span>
      <span class="divider"><xsl:text> </xsl:text></span>
      <span class="wording"><xsl:value-of select="./h1" /></span></a>
    <ul class="toc-module">
      <xsl:for-each select="./section">
        <li>
          <xsl:call-template name="toc-section" />
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- It's Tricky to rock a rhyme, to rock a rhyme that's right on time. -->
  <xsl:template name="toc-module">
    <xsl:variable name="toc-class">
      <xsl:choose>
        <xsl:when test="@data-type='preface'">
          <xsl:value-of select="'toc-module toc-preface-module'" />
        </xsl:when>
        <xsl:when test="@data-type='appendix'">
          <xsl:value-of select="'toc-module toc-appendix-module'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'toc-module'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
      <span class="label"><xsl:text> </xsl:text></span>
      <span class="number"><xsl:text> </xsl:text></span>
      <span class="divider"><xsl:text> </xsl:text></span>
       <span class="wording"><a href="#{@id}" class="{$toc-class}"><xsl:value-of select="./h1/span[@class='title-text']" /></a>
     </span>
  </xsl:template>

  <!-- It's Tricky...it's Tricky (Tricky) Tricky (Tricky) -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
