<?xml version="1.0"?>
<!-- $Id: elim.xsl,v 1.10 2005/02/01 14:23:05 dvd Exp $ -->

<xsl:transform
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rng="http://relaxng.org/ns/structure/1.0"
	xmlns="http://relaxng.org/ns/structure/1.0"
	exclude-result-prefixes="rng"
	version="1.0">

  <xsl:template match="/">
    <xsl:apply-templates mode="elim"/>
  </xsl:template>

  <xsl:template mode="elim" match="rng:include">
    <rng:div>
      <xsl:apply-templates mode="elim" select="*|@*|text()|comment()"/>
    </rng:div>
  </xsl:template>

  <xsl:template mode="elim" match="rng:define|rng:start">
    <xsl:call-template name="cp-unless-ovr">
      <xsl:with-param name="incelim" select="ancestor::rng:include[1]"/>
      <xsl:with-param name="define" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="cp-unless-ovr">
    <xsl:param name="incelim"/>
    <xsl:param name="define"/>
    <xsl:choose>
      <xsl:when test="$incelim
          and generate-id($define/ancestor::rng:grammar[1])
	    = generate-id($incelim/ancestor::rng:grammar[1])">

 	<xsl:if test="not(
          $incelim/preceding-sibling::*/descendant-or-self::*[
	    local-name($define)=local-name()
	    and (local-name($define)='start'
	      or (local-name($define)='define' and @name=$define/@name))
	    and generate-id(ancestor::rng:grammar[1])
	      = generate-id($incelim/ancestor::rng:grammar[1])])">
	  <xsl:call-template name="cp-unless-ovr">
	    <xsl:with-param name="incelim"
	      select="$incelim/ancestor::rng:include[1]"/>
	    <xsl:with-param name="define" select="$define"/>
	  </xsl:call-template>
	</xsl:if>
      </xsl:when>

      <xsl:otherwise>
        <xsl:copy>
	  <xsl:for-each select="$define">
	    <xsl:apply-templates mode="elim" select="*|@*|text()|comment()"/>
	  </xsl:for-each>
	</xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="elim" match="*|@*|text()|comment()">
    <xsl:copy>
  	<xsl:apply-templates mode="elim" select="*|@*|text()|comment()"/>
    </xsl:copy>
  </xsl:template>

</xsl:transform>
