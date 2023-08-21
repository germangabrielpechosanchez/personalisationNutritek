<?xml version="1.0" encoding="UTF-8"?>
<!-- declaration d'une feuille de style-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- encodage de sortie (par defaut XML) -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
	
	<!-- recopie de tous les élements (node=balise, @=attribut) -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
		
	
</xsl:stylesheet>
