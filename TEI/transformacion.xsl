<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns="http://www.w3.org/1999/xhtml">
                
    <xsl:template match="/">
        <xsl:variable name="doc_id" select="//title/@xml:id"/> 
        <!-- Recuperamos el id del documento en una variable para nombrar el archivo de salida -->
        <!-- Redirigir el resultado hacia un archivo -->        
        <xsl:result-document method="html" encoding="utf-8"
            href="objects/transcripciones/{$doc_id}.html" omit-xml-declaration="yes">---
        layout: default
        title: <xsl:apply-templates select="$doc_id"/>
       ---
       
        <!-- <h1><xsl:apply-templates select="//title[1]"/></h1> -->

        <div class="row clearfix">
            <xsl:apply-templates select="//body"/>
        </div>  


        </xsl:result-document>
        <!-- Redirigir el resultado hacia un archivo -->
    </xsl:template>


    <!-- Transformaciones -->


<xsl:template match="//p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>


    <!-- <xsl:template match="//lg[@type='poema']">      -->
        <!-- <p class="info"><xsl:value-of select="concat('Unisonancia: ', @unisonancia)"/></p>
        <p class="info"><xsl:value-of select="concat('Isometrismo: ', @isometrismo)"/></p>
        <p class="info"><xsl:value-of select="concat('Isoestrofismo: ', @isoestrofismo)"/></p>
        <p class="info"><xsl:value-of select="concat('Asonancia: ', @asonancia)"/></p> -->
        <!-- <p class="info"><xsl:value-of select="concat('Esquema métrico: ', @met)"/></p>
        <p class="info"><xsl:value-of select="concat('Esquema rimático: ', @rhyme)"/></p>
            <xsl:apply-templates/>
    </xsl:template> -->

 <xsl:template match="//lg">
        <div class="estrofa">
        <p class="info"><xsl:value-of select="concat('Esquema métrico: ', @met)"/></p>
        <p class="info"><xsl:value-of select="concat('Esquema rimático: ', @rhyme)"/></p>
            <xsl:apply-templates/>
        </div>
    </xsl:template>   
   
    <xsl:template match="//l">
        <p class="verso">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

        <xsl:template match="//l[@rendition='estribillo']">
        <p class="estribillo">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//rhyme">
        <span class="rima"> 
            <xsl:apply-templates/>
        </span>
    </xsl:template>   


    <xsl:template match="//expan">
        <i> 
            <xsl:apply-templates/>
        </i>
    </xsl:template>   

    <xsl:template match="//placeName">
    <a>
        <xsl:attribute name="class">pop-annotation</xsl:attribute>
        <xsl:attribute name="tabindex">0</xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@key"/></xsl:attribute>
        <xsl:apply-templates/>
        </a>
    </xsl:template>   
    
    
    <xsl:template match="//persName">
    <a>
        <xsl:attribute name="class">pop-annotation</xsl:attribute>
        <xsl:attribute name="tabindex">0</xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@key"/></xsl:attribute>
        <xsl:apply-templates/>
        </a>
    </xsl:template>  

    

      
    <xsl:template match="//note">
    <a>
        <xsl:attribute name="class">pop-annotation</xsl:attribute>
        <xsl:attribute name="tabindex">0</xsl:attribute>
        <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
        <xsl:apply-templates/>
        </a>
    </xsl:template>   
    
    <xsl:template match="//corr">
        <span> 
            <xsl:attribute name="style">font-style: italic;</xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>

        <xsl:template match="//speaker">
        <p class="speaker"> 
            -<xsl:apply-templates/>
        </p>
    </xsl:template>


    <xsl:template match="//lb">
        <br/> 
    </xsl:template>

        <xsl:template match="//head">
        <h4> 
            <xsl:apply-templates/>
        </h4>
    </xsl:template>

           <xsl:template match="//head[@type='subtitulo']">
        <h4> 
            -<xsl:apply-templates/>
        </h4>
    </xsl:template>

        <xsl:template match="//pb">
        <p class="folio"> 
            Folio: <xsl:value-of select="@n"/>
        </p>
    </xsl:template>

    <xsl:template match="//del">
        <span class="del"> 
         <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="//add">
        <span class="add"> 
         <xsl:apply-templates/>
        </span>
    </xsl:template>

</xsl:stylesheet>