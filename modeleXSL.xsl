<?xml version="1.0" encoding="UTF-8"?>
<!-- declaration d'une feuille de style-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- déclaration des paramétres-->
	<xsl:param name="Civilite"/>
	<xsl:param name="UF"/>
	
	
	<!-- format de sortie (par defaut XML -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- recopie de tous les élements (node=balise, @=attribut) -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- remplace civilite par MR -->
	<!-- 1ère méthode-->
	<xsl:template match="//PID.6.5">
		<xsl:element name="PID.6.5">MR</xsl:element>
	</xsl:template>
	
	<!-- 2éme méthode-->
	<xsl:template match="//PID.6.5/text()">MR</xsl:template>
	
<!-- remplace civilite par la valeur du paramétre passé à travers le XSL -->
	<xsl:template match="//PID.6.5/text()">
		<xsl:value-of select="$Civilite"/>
	</xsl:template>
	
	<!--Remplacer PV1.4.1 par ZBE.8.10	-->
	<xsl:variable name="UFR" select="//ZBE.8.10/text()"/>
	
	<xsl:template match="//PV1.4.1/text()">
		<xsl:value-of select="$UFR"/>
	</xsl:template>
	
	<!-- je concatene PV1.3.1 avec ZBE.8.10 si il est égal à R, sinon je laisse la valeur initiale-->
<!--1ère méthode-->
	<xsl:template match="//PV1.3.1/text()">

		<xsl:if test=".='R'">
			<xsl:value-of select="concat(.,$UFR)"/>
		</xsl:if>
		
		<xsl:if test=".!='R'">
			<xsl:value-of select="."/>
		</xsl:if>
	
	</xsl:template>

<!--2ème méthode-->
<xsl:template match="//PV1.3.1[.='R']/text()">
	<xsl:value-of select="concat(.,$UFR)"/>
</xsl:template>
	
	<!-- mettre à vide la 2éme occurence du PV1.8.1 -->
	<xsl:template match="//PV1.8.1[2]/text()">
	</xsl:template>
	
	<!-- supprimer le PD1 -->
	<xsl:template match="//PD1">
	</xsl:template>
	
	<!-- inserer une constante dans le champ PID.5.1, sachant qu'il n'existe pas, et etant sûre que PID.6.1 existe -->
	<!-- on supprime avant toute valeur preéxistante -->
	<xsl:template match="//PID.5.1"></xsl:template>
	<xsl:template match="//PID.6.1">
		<xsl:element name="PID.5.1">CONSTANTE</xsl:element>
		<xsl:element name="PID.6.1"><xsl:value-of select="./text()"/></xsl:element>
		
	</xsl:template>
	
	<!-- Teste l'existence du segment EVN.3.1, pour le rajouter -->
	<xsl:template match="//EVN.2.1">
		<!-- S'il n'y a pas de segment EVN.3.1 -->
		<xsl:if test="not(//EVN.3.1)">
			<EVN.2.1><xsl:value-of select="./text()"/></EVN.2.1>
			<EVN.3.1>TEST</EVN.3.1>
		</xsl:if>
		<!-- Si le segment EVN.3.1 existe -->
		<xsl:if test="//EVN.3.1">
			<EVN.2.1><xsl:value-of select="./text()"/></EVN.2.1>
		</xsl:if>
	</xsl:template>
	
	<!-- Teste si le contenu d'un segment est vide, pour le remplacer -->
	<xsl:template match="//ROL.5.3">
		<xsl:if test="not(./text())">
			<ROL.5.3>TEST</ROL.5.3>
		</xsl:if>
		<xsl:if test="./text()">
			<ROL.5.3>
				<xsl:value-of select="./text()"/>
			</ROL.5.3>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>