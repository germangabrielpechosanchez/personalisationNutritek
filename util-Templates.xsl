<?xml version="1.0" encoding="UTF-8"?>
<!--
  But : Librairie de modèles et fonctions xsl génériques

  No. Date       User     Description / commentaires (Optionnel)
  +++ ++++++++++ ++++++++ +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
  5   2020-01-07 lajrob01 Ajout de LPAD et RPAD au template string
  4   2019-08-07 voymic01 Suppression des templates BaliseJSON et BaliseHL7, car ne seront plus nécessaires en version esV2 2.44 et +
                          Changement dans les valeurs par défaut des templates Balise et BaliseDesc pour ls versions esV2 2.44 et +
  3   2018-12-10 lajrob01 Correction de util:formatDateTime, ajout du template Boolean 
  2   2018-09-18 Farid    Ajout des templates Balise, BaliseBoolean et BaliseDescr 
  1              JP C.    Création
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:functx="http://www.functx.com" xmlns:util="http://whatever" extension-element-prefixes="exsl" exclude-result-prefixes="#all" version="2.0">

   <!-- Inclusion des Templates  -->
   <xsl:include href="util-Functx.xsl"/>

   <!-- *************************************************************************************  -->
   <!-- Template : string                                                                      -->
   <!--                                                                                        -->
   <!-- Transformation de la chaine de caractère                                               -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères à traiter                                           -->
   <!-- format_out  = chaine delimité par | contenant la liste des opérations à appliquer      -->
   <!--               NOACCENT - retirer les lettres accentuées                                -->
   <!--               LOWER - mettre en majuscule                                              -->
   <!--               UPPER - mettre en minuscule                                              -->
   <!--               INITCAP - mettre en minuscule, première lettre en majuscule              -->
   <!--               TRIM - enlever les espaces au début et à la fin de la chaine             -->
   <!--               LTRIM - enlever les espaces au début de la chaine                        -->
   <!--               RTRIM - enlever les espaces à la fin de la chaine                        -->
   <!--               NOLEADINGZERO - enlever les zéro non-significatifs                       -->
   <!--               RPAD - Coupe la chaîne à la longueur voulue ou concatène, à droite 
                           de le string, le caractère spécifié à la string jusqu'à la 
                           longueur voulue                                                     -->
   <!--               LPAD - Coupe la chaîne à la longueur voulue ou concatène, à gauche
                           de le string, le caractère spécifié à la string jusqu'à la 
                           longueur voulue                                                     -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--      <xsl:call-template name="string">                                                 -->
   <!--          <xsl:with-param name="str" select="."/>                                       -->
   <!--          <xsl:with-param name="format_out" select="'LOWER | RPAD'"/>                   -->
   <!--          <xsl:with-param name="str_pad" select="'#'"/>                                 -->
   <!--          <xsl:with-param name="str_len" select="20"/>                                  -->
   <!--      </xsl:call-template>                                                              -->
   <!-- *************************************************************************************  -->
   <xsl:template name="string">
      <xsl:param name="str" as="xs:string"/>
      <xsl:param name="format_out" as="xs:string"/>
      <xsl:param name="str_pad" as="xs:string" select="'*'"/>
      <xsl:param name="str_len" as="xs:integer" select="0"/>

      <xsl:variable name="tStr">
         <xsl:value-of select="$str"/>
      </xsl:variable>

      <xsl:variable name="tFormat">
         <xsl:value-of select="upper-case($format_out)"/>
      </xsl:variable>

      <xsl:variable name="tStr">
         <xsl:choose>
            <xsl:when test="functx:contains-word($tFormat, 'NOACCENT')">
               <xsl:value-of select="util:removeAccent($tStr)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$tStr"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="tStr">
         <xsl:choose>
            <xsl:when test="functx:contains-word($tFormat, 'UPPER')">
               <xsl:value-of select="upper-case($tStr)"/>
            </xsl:when>
            <xsl:when test="functx:contains-word($tFormat, 'LOWER')">
               <xsl:value-of select="lower-case($tStr)"/>
            </xsl:when>
            <xsl:when test="functx:contains-word($tFormat, 'INITCAP')">
               <xsl:value-of select="functx:capitalize-first(lower-case($tStr))"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$tStr"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="tStr">
         <xsl:choose>
            <xsl:when test="functx:contains-word($tFormat, 'LTRIM')">
               <xsl:value-of select="functx:left-trim($tStr)"/>
            </xsl:when>
            <xsl:when test="functx:contains-word($tFormat, 'RTRIM')">
               <xsl:value-of select="functx:right-trim($tStr)"/>
            </xsl:when>
            <xsl:when test="functx:contains-word($tFormat, 'TRIM')">
               <xsl:value-of select="functx:trim($tStr)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$tStr"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="tStr">
         <xsl:choose>
            <xsl:when test="functx:contains-word($tFormat, 'LPAD')">
               <xsl:variable name="padLen">
                  <xsl:choose>
                     <xsl:when test="$str_len = 0">
                        <xsl:value-of select="0"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$str_len - string-length($tStr)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="$padLen &gt; 0">
                     <xsl:variable name="pad">
                        <xsl:for-each select="1 to $padLen">
                           <xsl:value-of select="$str_pad"/>
                        </xsl:for-each>
                     </xsl:variable>
                     <xsl:value-of select="concat($pad, $tStr)"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="substring($tStr, 1, $str_len)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$tStr"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="tStr">
         <xsl:choose>
            <xsl:when test="functx:contains-word($tFormat, 'RPAD')">
               <xsl:value-of select="functx:pad-string-to-length($tStr, $str_pad, $str_len)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$tStr"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="tStr">
         <xsl:choose>
            <xsl:when test="functx:contains-word($tFormat, 'NOLEADINGZERO')">
               <xsl:value-of select="util:removeLeadingZero($tStr)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$tStr"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:value-of select="$tStr"/>
   </xsl:template>


   <!-- *************************************************************************************  -->
   <!-- Template : stringInList                                                                -->
   <!--                                                                                        -->
   <!-- Retourne la Xième sous-chaine d'une chaine délimitée                                   -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères délimitée à traiter                                 -->
   <!-- del         = delimiteur utilisé                                                       -->
   <!-- pos         = position de la sous-chaine à extraire                                    -->
   <!-- default     = valeur de défaut à retourner                                             -->
   <!--               si valeur = exception alors arrêt de traitement                          -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--      <xsl:call-template name="stringInList">                                           -->
   <!--          <xsl:with-param name="str"      select="."/>                                  -->
   <!--          <xsl:with-param name="del"      select="'-'"/>                                -->
   <!--          <xsl:with-param name="pos"      select="2"/>                                  -->
   <!--          <xsl:with-param name="default"  select="."/>                                  -->
   <!--      </xsl:call-template>                                                              -->
   <!-- *************************************************************************************  -->
   <xsl:template name="stringInList">
      <xsl:param name="str" as="xs:string"/>
      <xsl:param name="del" as="xs:string"/>
      <xsl:param name="pos" as="xs:integer"/>
      <xsl:param name="default" as="xs:string"/>
      <xsl:value-of select="util:getStringInList($str, $del, $pos, $default)"/>
   </xsl:template>


   <!-- *************************************************************************************  -->
   <!-- Template : stringCodeMap                                                               -->
   <!--                                                                                        -->
   <!-- Retourne la valeur correspondante selon les listes de valeurs passées en paramètre     -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères à traiter                                           -->
   <!-- list_in     = liste des valeurs reçues                                                 -->
   <!-- list_out    = liste des valeurs à envoyer                                              -->
   <!-- default     = valeur de défaut à retourner                                             -->
   <!--               si valeur = exception alors arrêt de traitement                          -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--      <xsl:variable name= "table_in"    select="tokenize('1,2,3,4,5',',')"/>            -->
   <!--      <xsl:variable name= "table_out"   select="tokenize('A,B,C,D,E',',')"/>            -->
   <!--      <xsl:call-template name="stringCodeMap">                                          -->
   <!--            <xsl:with-param name="str"        select="."/>                              -->
   <!--            <xsl:with-param name="list_in"    select="$table_in"/>                      -->
   <!--            <xsl:with-param name="list_out"   select="$table_out"/>                     -->
   <!--            <xsl:with-param name="default"    select="'exception"/>                     -->
   <!--      </xsl:call-template>                                                              -->
   <!-- *************************************************************************************  -->
   <xsl:template name="stringCodeMap">
      <xsl:param name="str" as="xs:string"/>
      <xsl:param name="list_in"/>
      <xsl:param name="list_out"/>
      <xsl:param name="default" as="xs:string"/>
      <xsl:value-of select="util:getCodeMap($str, $list_in, $list_out, $default)"/>
   </xsl:template>


   <!-- *************************************************************************************  -->
   <!-- Template : time                                                                        -->
   <!--                                                                                        -->
   <!-- Transformation d'un élément de type time (heure,minute,seconce,centième de seconde)    -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères à traiter                                           -->
   <!-- format_in   = format attendu du paramètre str_in                                       -->
   <!--               où HH = heure                                                            -->
   <!--                  mm = minute                                                           -->
   <!--                  SS = seconde                                                          -->
   <!--                  ss = centième de seconde                                              -->
   <!-- format_out  = format de retour                                                         -->
   <!--               voir  https://www.w3.org/TR/xslt20/#date-picture-string                  -->
   <!-- default     = valeur de défaut à retourner                                             -->
   <!--               '' = aucune                                                              -->
   <!--               now = date et heure courrant                                             -->
   <!--               ou une formule selon le format suivante                                  -->
   <!--               [P|-P][999Y][999M][999D]T[999H][999M][999S]                              -->
   <!--               exemple: Ajoute 3 heures et 15 minutes = P3DT15M                         -->
   <!--                        Enlever 120 secondes = -PT120S                                  -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:call-template name="time">                                                    -->
   <!--         <xsl:with-param name="str"        select="'1734'"/>                            -->
   <!--         <xsl:with-param name="format_in"  select="'HHMM'"/>                            -->
   <!--         <xsl:with-param name="format_out" select="'[H01]:[m01]'"/>                     -->
   <!--         <xsl:with-param name="default"    select="'PT10M'"/>                           -->
   <!--     </xsl:call-template>                                                               -->
   <!--     ** RÉSULTAT=  17:44 **                                                             -->
   <!-- *************************************************************************************  -->
   <xsl:template name="time">
      <xsl:param name="str"/>
      <xsl:param name="format_in"/>
      <xsl:param name="format_out"/>
      <xsl:param name="default"/>
      <xsl:value-of select="util:formatTime($str, $format_in, $format_out, $default)"/>
   </xsl:template>


   <!-- *************************************************************************************  -->
   <!-- Template : dateTime                                                                    -->
   <!--                                                                                        -->
   <!-- Transformation d'un élément de type date et heure                                      -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères à traiter                                           -->
   <!-- format_in   = format attendu du paramètre str_in                                       -->
   <!--               où CC = siècle                                                           -->
   <!--                  YY = année                                                            -->
   <!--                  MM = mois                                                             -->
   <!--                  DD = jour                                                             -->
   <!--                  HH = heure                                                            -->
   <!--                  mm = minute                                                           -->
   <!--                  SS = seconde                                                          -->
   <!--                  ss = centième de seconde                                              -->
   <!-- format_out  = format de retour                                                         -->
   <!--               voir  https://www.w3.org/TR/xslt20/#date-picture-string                  -->
   <!-- default     = valeur de défaut à retourner                                             -->
   <!--               '' = aucune                                                              -->
   <!--               now = date et heure courrant                                             -->
   <!--               ou une formule selon le format suivante                                  -->
   <!--               [P|-P][999Y][999M][999D]T[999H][999M][999S]                              -->
   <!--               exemple: Ajoute 3 heures et 15 minutes = P3DT15M                         -->
   <!--                        Enlever 120 secondes = -PT120S                                  -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:call-template name="dateTime">                                                -->
   <!--         <xsl:with-param name="str"        select="'20180115 1734'"/>                   -->
   <!--         <xsl:with-param name="format_in"  select="'CCYYMMDD HHMI'"/>                   -->
   <!--         <xsl:with-param name="format_out" select="'[Y0001]-[M01]-[D01] [H01]:[m01]'"/> -->
   <!--         <xsl:with-param name="default"    select="'P1D'"/>                             -->
   <!--     </xsl:call-template>                                                               -->
   <!--     ** RÉSULTAT=  2018-01-16 17:34 **                                                  -->
   <!-- *************************************************************************************  -->
   <xsl:template name="dateTime">
      <xsl:param name="str"/>
      <xsl:param name="format_in"/>
      <xsl:param name="format_out"/>
      <xsl:param name="default"/>
      <xsl:value-of select="util:formatDateTime($str, $format_in, $format_out, $default)"/>
   </xsl:template>


   <!-- *************************************************************************************  -->
   <!-- Template : dateExpiredNAM                                                              -->
   <!--                                                                                        -->
   <!-- Transformation d'un élément de type date d'expiration NAM                              -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères à traiter                                           -->
   <!-- format_in   = format attendu du paramètre str_in                                       -->
   <!--               où CC = siècle                                                           -->
   <!--                  YY = année                                                            -->
   <!--                  MM = mois                                                             -->
   <!--                  DD = jour                                                             -->
   <!-- format_out  = format de retour                                                         -->
   <!--               où CC = siècle                                                           -->
   <!--                  YY = année                                                            -->
   <!--                  MM = mois                                                             -->
   <!--                  DD = jour                                                             -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:call-template name="dateExpirationNAM">                                       -->
   <!--         <xsl:with-param name="str"        select="'1803'"/>                            -->
   <!--         <xsl:with-param name="format_in"  select="'YYMM'"/>                            -->
   <!--         <xsl:with-param name="format_out" select="'CCYY-MM'"/>                         -->
   <!--     </xsl:call-template>                                                               -->
   <!--     ** RÉSULTAT=  2018-03 **                                                           -->
   <!--                                                                                        -->
   <!--     Si le siècle est absent alors si MM > 80 alors 19 sinon 20                         -->
   <!-- *************************************************************************************  -->
   <xsl:template name="dateExpiredNAM">
      <xsl:param name="str"/>
      <xsl:param name="format_in"/>
      <xsl:param name="format_out"/>
      <xsl:variable name="posCC" select="util:indexOf($format_in, 'CC')"/>
      <xsl:variable name="posYY" select="util:indexOf($format_in, 'YY')"/>
      <xsl:variable name="posMM" select="util:indexOf($format_in, 'MM')"/>
      <xsl:variable name="posDD" select="util:indexOf($format_in, 'DD')"/>
      <xsl:variable name="MM" select="substring($str, $posMM, 2)"/>
      <xsl:variable name="YY" select="substring($str, $posYY, 2)"/>
      <xsl:variable name="CC">
         <xsl:choose>
            <xsl:when test="$posCC ne '0'">
               <xsl:value-of select="substring($str, $posCC, 2)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="$YY &gt; '80'">
                     <xsl:value-of select="'19'"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="'20'"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="pDD">
         <xsl:choose>
            <xsl:when test="$posDD ne '0'">
               <xsl:value-of select="'01'"/>
            </xsl:when>
            <xsl:otherwise>><xsl:value-of select="substring($str, $posDD, 2)"/></xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="replace(replace(replace(replace($format_out, 'CC', $CC), 'YY', $YY), 'MM', $MM), 'DD', '01')"/>
   </xsl:template>


   <!-- *************************************************************************************  -->
   <!-- Template : phoneNumber                                                                 -->
   <!--                                                                                        -->
   <!-- Transformation d'un élément de type numéro de téléphone                                -->
   <!--                                                                                         -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères à traiter                                           -->
   <!-- format_out  = format de retour                                                         -->
   <!--               où RRR  = indicatif régional                                             -->
   <!--                  AAA  = code de secteur (area code)                                    -->
   <!--                  NNNN = numéro                                                         -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:call-template name="phoneNumber">                                             -->
   <!--         <xsl:with-param name="str"        select="."/>                                 -->
   <!--         <xsl:with-param name="format_out" select="'(RRR) AAA-NNNN'"/>                  -->
   <!--     </xsl:call-template>                                                               -->
   <!--                                                                                        -->
   <!-- *************************************************************************************  -->
   <xsl:template name="phoneNumber">
      <xsl:param name="str"/>
      <xsl:param name="format_out"/>

      <xsl:variable name="str1" select="normalize-space(translate($str, '()-', ''))"/>
      <xsl:variable name="format_in">
         <xsl:variable name="len" as="xs:integer">
            <xsl:value-of select="number(string-length($str1))"/>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="$len &gt; 9">
               <xsl:value-of select="'RRRAAANNNNN'"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'AAANNNNN'"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="posRRR" select="util:indexOf($format_in, 'RRR')"/>
      <xsl:variable name="posAAA" select="util:indexOf($format_in, 'AAA')"/>
      <xsl:variable name="posNNNN" select="util:indexOf($format_in, 'NNNN')"/>
      <xsl:variable name="RRR">
         <xsl:choose>
            <xsl:when test="$posRRR ne '0'">
               <xsl:value-of select="substring($str1, $posRRR, 3)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'   '"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="AAA">
         <xsl:choose>
            <xsl:when test="$posAAA ne '0'">
               <xsl:value-of select="substring($str1, $posAAA, 3)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'   '"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="NNNN">
         <xsl:choose>
            <xsl:when test="$posNNNN ne '0'">
               <xsl:value-of select="substring($str1, $posNNNN, 4)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'    '"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="normalize-space(replace(replace(replace($format_out, 'RRR', $RRR), 'AAA', $AAA), 'NNNN', $NNNN))"/>
   </xsl:template>


   <!-- *************************************************************************************  -->
   <!-- Template : licenceDoctor                                                               -->
   <!--                                                                                        -->
   <!-- Transformation d'un élément de type numéro de permis du collège des médecins           -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str           = chaine de caractères à traiter                                         -->
   <!-- removeFirst-1 = [ENABLE|DISABLE] si longueur > 6 et premier caractère = 1              -->
   <!--                          alors enlever le premier 1                                    -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:call-template name="licenceDoctor">                                           -->
   <!--         <xsl:with-param name="str"           select="."/>                              -->
   <!--         <xsl:with-param name="removeFirst-1" select="'enable'"/>                       -->
   <!--     </xsl:call-template>                                                               -->
   <!--                                                                                        -->
   <!-- *************************************************************************************  -->
   <xsl:template name="licenceDoctor">
      <xsl:param name="str"/>
      <xsl:param name="removeFirst-1"/>
      <xsl:choose>
         <xsl:when test="upper-case($removeFirst-1) eq 'ENABLE' and string($str) and string-length($str) = 6 and number($str) = number($str)">
            <xsl:value-of select="substring($str, 1, 5)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$str"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- ******************************************************************************************  -->
   <!-- Template : Boolean                                                                          -->
   <!--                                                                                             -->
   <!-- Retourne Y/N ou 0/1 d'une expression booléenne                                              -->
   <!--                                                                                             -->
   <!-- Paramètres:                                                                                 -->
   <!-- boolean   = valeur boolean à évaluer                                                        -->
   <!-- numeric   = indique si la valeur boolean est exprimée en numérique                          -->
   <!-- Exemple                                                                                     -->
   <!--     <xsl:call-template name="Boolean">                                                      -->
   <!--        <xsl:with-param name="numeric" select="'true'"/>                                     -->
   <!--        <xsl:with-param name="boolean" select="./blockedFields/familyNameBlocked/text()"/>   -->
   <!--     </xsl:call-template>                                                                    -->
   <!--                                                                                             -->
   <!-- ******************************************************************************************  -->
   <xsl:template name="Boolean">
      <xsl:param name="boolean"/>
      <xsl:param name="numeric" select="'false'"/>
      <xsl:choose>
         <xsl:when test="$numeric = 'false' and $boolean = 'true'">Y</xsl:when>
         <xsl:when test="$numeric = 'false' and $boolean != 'true'">N</xsl:when>
         <xsl:when test="$numeric != 'false' and $boolean = 'true'">1</xsl:when>
         <xsl:when test="$numeric != 'false' and $boolean != 'true'">0</xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat($numeric, $boolean)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- *************************************************************************************  -->
   <!-- Template : Hl7GenereBaliseParent                                                       -->
   <!--                                                                                        -->
   <!-- Retourne une liste de noeud regroupés sous un noeud parent afin de facilier les traitements-->
   <!-- Exemple:
            <test.2.1>a21</test.2.1>
            <test.2.2>a22</test.2.2>
            <test.2.3>a23</test.2.3>
            <test.2.4>a24</test.2.4>
            <test.2.1>b21</test.2.1>
            <test.2.2>b22</test.2.2>
            <test.2.3>b23</test.2.3>
            <test.2.4>b24</test.2.4>
            <test.2.1>c21</test.2.1>
            <test.2.2>c22</test.2.2>
            <test.2.3>c23</test.2.3>
            <test.2.4>c24</test.2.4>
    Devient
            <test.2>
                <test.2.1>a21</test.2.1>
                <test.2.2>a22</test.2.2>
                <test.2.3>a23</test.2.3>
                <test.2.4>a24</test.2.4>
            </test.2>
            <test.2>
                <test.2.1>b21</test.2.1>
                <test.2.2>b22</test.2.2>
                <test.2.3>b23</test.2.3>
                <test.2.4>b24</test.2.4>
            </test.2>
            <test.2>
                <test.2.1>c21</test.2.1>
                <test.2.2>c22</test.2.2>
                <test.2.3>c23</test.2.3>
                <test.2.4>c24</test.2.4>
            </test.2>-->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- Hl7AncienneBaliseParent     = Noeud Parent qui contient les noeuds à regrouper               -->
   <!-- ElementRegroupe       = Nom du la balise qui va regrouper les noeuds                   -->
   <!-- Exemple                                                                                -->
   <!--	Créer les balises pour permettre de regrouper-->
   <!--<xsl:template match="//test.2.1[1]" priority="2" >
            <xsl:variable name="vNodes" as="element()*">
                <xsl:call-template name="Hl7GenereBaliseParent">
                    <xsl:with-param name="Hl7GenereBaliseParent" select="./parent::node()"></xsl:with-param>
                    <xsl:with-param name="ElementRegroupe">test.2</xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
        </xsl:template>
        <xsl:template match="//test.2.1" priority="1"/>-->
   <!-- *************************************************************************************  -->
   <xsl:template name="Hl7GenereBaliseParent" as="element()*">
      <xsl:param name="Hl7AncienneBaliseParent"/>
      <xsl:param name="ElementRegroupe"/>
      <!-- Nom élément répétitif (ex.: PID.4) -->

      <xsl:variable name="ElementRepete" select="concat($ElementRegroupe, '.1')"/>
      <!-- Nom de premier élément répétitif (ex.: PID.4.1) -->
      <xsl:variable name="varContains" select="substring($ElementRepete, 1, functx:index-of-string-last($ElementRepete, '.'))"/>


      <xsl:for-each select="$Hl7AncienneBaliseParent/*">
         <!-- <name><xsl:value-of select="name()"/></name>-->
         <xsl:choose>
            <xsl:when test="name() = $ElementRepete">
               <!--<when><xsl:value-of select="name()"/></when>-->
               <xsl:variable name="varCount" select="count(preceding-sibling::node()[name() = $ElementRepete]) + 1"/>
               <!--<varCount><xsl:value-of select="$varCount"/></varCount>-->
               <xsl:variable name="varValeurPremierElement" select="."/>
               <!--<varValeurPremierElement><xsl:value-of select="$varValeurPremierElement"/></varValeurPremierElement>-->
               <xsl:element name="{$ElementRegroupe}">
                  <xsl:copy>
                     <xsl:apply-templates select="node()"/>
                  </xsl:copy>
                  <xsl:copy-of select="following-sibling::*[contains(name(), $varContains)][name() != $ElementRepete][count(preceding-sibling::node()[name() = $ElementRepete]) = $varCount]"/>
               </xsl:element>
            </xsl:when>
            <xsl:when test="contains(name(), $varContains)"/>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>

   <!-- *************************************************************************************  -->
   <!-- Template : Hl7GenereRegroupement                                                                      -->
   <!--                                                                                        -->
   <!-- Retourne un noeud XML dans lequel on regroupe les éléments en fonction du ABC.#.1      -->
   <!-- Sous une balise ABC.#                                                                  -->
   <!-- Paramètres:                                                                            -->
   <!-- Hl7SegmentARegrouper   = noeud XML pour lesquels on veut regrouper les sous-noeuds     -->
   <!-- Exemple d'appel:                                                                               -->
   <!--    <xsl:template match="/">
                <xsl:variable name="vNodes" as="element()*">
                <xsl:call-template name="Hl7GenereRegroupement">
                    <xsl:with-param name="Hl7SegmentARegrouper" select="//PID"></xsl:with-param>
                </xsl:call-template>
                </xsl:variable>
                <xsl:copy-of select="$vNodes"/>
            </xsl:template>-->
   <!-- *************************************************************************************  -->

   <xsl:template name="Hl7GenereRegroupement" as="element()*">
      <xsl:param name="Hl7SegmentARegrouper"/>
      <xsl:for-each select="$Hl7SegmentARegrouper/*">
         <xsl:choose>
            <xsl:when test="ends-with(./name(), '.1')">
               <xsl:variable name="ElementName" select="./name()"/>
               <xsl:variable name="GroupElementName" select="substring(./name(), 1, string-length(./name()) - 2)"/>
               <xsl:variable name="varCount" select="count(preceding-sibling::node()[name() = $ElementName]) + 1"/>
               <xsl:element name="{$GroupElementName}">
                  <xsl:copy-of select="."/>
                  <xsl:copy-of
                     select="following-sibling::*[contains(name(), concat($GroupElementName, '.'))][name() != $ElementName][count(preceding-sibling::node()[name() = $ElementName]) = $varCount]"/>
               </xsl:element>
            </xsl:when>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>

   <!-- *************************************************************************************  -->
   <!-- Template : Balise                                                                      -->
   <!--                                                                                        -->
   <!-- Retourne une balise qui contient une valeur donnée ou une valeur par défaut.           -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- TagName     = Nom du noeud créé                                                        -->
   <!-- newValue    = valeur à insérer dans la balise                                          -->
   <!-- defValue    = valeur entrée par défaut si newValue est null ou vide.                   -->
   <!-- Exemple                                                                                -->
   <!--			<xsl:call-template name="Balise">                                           -->
   <!--				<xsl:with-param name="TagName" select="'messageId'"/>                   -->
   <!--				<xsl:with-param name="newValue" select="//MSH/MSH.10.1/text()"/>        -->
   <!--			</xsl:call-template>                                                        -->
   <!-- *************************************************************************************  -->
   <xsl:template name="Balise">
      <xsl:param name="TagName"/>
      <xsl:param name="newValue"/>
      <xsl:param name="defValue"/>

      <xsl:variable name="TestValue">
         <xsl:choose>
            <xsl:when test="empty($newValue)">
               <xsl:value-of select="$newValue"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="string">
                  <xsl:with-param name="str" select="$newValue"/>
                  <xsl:with-param name="format_out" select="'TRIM'"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="($TestValue = null) or (string($TestValue) = '') or empty($TestValue)">
            <xsl:choose>
               <xsl:when test="$defValue = 'EMPTY'"/>
               <xsl:when test="not(string($defValue) = '')">
                  <xsl:element name="{$TagName}">
                     <xsl:value-of select="$defValue"/>
                  </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:element name="{$TagName}"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="{$TagName}">
               <!--<xsl:value-of select="$newValue"/>-->
               <xsl:for-each select="$newValue">
                  <xsl:value-of select="."/>
                  <xsl:if test="not(position() = last())"> - </xsl:if>
               </xsl:for-each>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- *************************************************************************************  -->
   <!-- Function : BaliseBooleen                                                               -->
   <!--                                                                                        -->
   <!-- Retourne une balise qui contient une valeur booléenne donnée ou une valeur par défaut. -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- TagName     = Nom du noeud créé                                                        -->
   <!-- newValue    = valeur booléenne à insérer dans la balise                                -->
   <!-- defValue    = valeur booléenne entrée par défaut si newValue est null ou vide.         -->
   <!-- Exemple                                                                                -->
   <!--			<xsl:call-template name="BaliseBooleen">                                    -->
   <!--				<xsl:with-param name="TagName" select="'deathIndicator'"/>              -->
   <!--				<xsl:with-param name="newValue" select="//PID/PID.30.1/text()"/>        -->
   <!--			</xsl:call-template>                                                        -->
   <!-- *************************************************************************************  -->

   <xsl:template name="BaliseBooleen">
      <xsl:param name="TagName"/>
      <xsl:param name="newValue"/>
      <xsl:param name="defValue"/>
      <xsl:choose>
         <xsl:when test="($newValue = null) or (string($newValue) = '') or empty($newValue)">
            <xsl:choose>
               <xsl:when test="not(string($defValue) = '')">
                  <xsl:element name="{$TagName}">
                     <xsl:attribute name="type">boolean</xsl:attribute>
                     <xsl:value-of select="$defValue"/>
                  </xsl:element>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="$newValue = '1'">
                  <xsl:element name="{$TagName}"><xsl:attribute name="type">boolean</xsl:attribute>true</xsl:element>
               </xsl:when>
               <xsl:when test="(upper-case($newValue) = 'Y') or (upper-case($newValue) = 'YES') or (upper-case($newValue) = 'TRUE')">
                  <xsl:element name="{$TagName}"><xsl:attribute name="type">boolean</xsl:attribute>true</xsl:element>
               </xsl:when>
               <xsl:when test="(upper-case($newValue) = 'O') or (upper-case($newValue) = 'OUI') or (upper-case($newValue) = 'VRAI')">
                  <xsl:element name="{$TagName}"><xsl:attribute name="type">boolean</xsl:attribute>true</xsl:element>
               </xsl:when>
               <xsl:when test="$newValue = '0'">
                  <xsl:element name="{$TagName}"><xsl:attribute name="type">boolean</xsl:attribute>false</xsl:element>
               </xsl:when>
               <xsl:when test="(upper-case($newValue) = 'N') or (upper-case($newValue) = 'NO') or (upper-case($newValue) = 'FALSE')">
                  <xsl:element name="{$TagName}"><xsl:attribute name="type">boolean</xsl:attribute>false</xsl:element>
               </xsl:when>
               <xsl:when test="(upper-case($newValue) = 'N') or (upper-case($newValue) = 'NON') or (upper-case($newValue) = 'FAUX')">
                  <xsl:element name="{$TagName}"><xsl:attribute name="type">boolean</xsl:attribute>false</xsl:element>
               </xsl:when>
               <xsl:otherwise><!--<xsl:element name="{$TagName}">null</xsl:element>--></xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- *************************************************************************************  -->
   <!-- Function : BaliseDescr                                                                 -->
   <!--                                                                                        -->
   <!-- Retourne une balise qui contient deux sous-balises qui contiennent une description     -->
   <!-- en français et une description en anglais.                                             -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- TagName     = Nom du noeud créé                                                        -->
   <!-- frValue     = Valeur de la description en français à insérer dans la sous-balise fr_CA.-->
   <!-- enValue     = Valeur de la description en anglais à insérer dans la sous-balise en_CA. -->
   <!--               Est équivalente à frValue.                                               -->
   <!-- defValue    = Valeur entrée par défaut si frValue est null ou vide.                    -->
   <!-- Exemple                                                                                -->
   <!--			<xsl:call-template name="BaliseBooleen">                                    -->
   <!--				<xsl:with-param name="TagName" select="'deathIndicator'"/>              -->
   <!--				<xsl:with-param name="newValue" select="//PID/PID.30.1/text()"/>        -->
   <!--			</xsl:call-template>                                                        -->
   <!-- *************************************************************************************  -->

   <xsl:template name="BaliseDescr">
      <xsl:param name="TagName"/>
      <xsl:param name="frValue"/>
      <xsl:param name="enValue">
         <xsl:value-of select="$frValue"/>
      </xsl:param>
      <xsl:param name="defValue"/>


      <xsl:variable name="TestValue">
         <xsl:choose>
            <xsl:when test="empty($frValue)">
               <xsl:value-of select="$frValue"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="string">
                  <xsl:with-param name="str" select="$frValue"/>
                  <!--enlever les espaces au début et à la fin de la chaine-->
                  <xsl:with-param name="format_out" select="'TRIM'"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="($TestValue = null) or (string($TestValue) = '') or empty($TestValue)">
            <xsl:element name="{$TagName}">
               <fr_CA>
                  <xsl:value-of select="$defValue"/>
               </fr_CA>
               <en_CA>
                  <xsl:value-of select="$defValue"/>
               </en_CA>
            </xsl:element>

            <!--                <xsl:choose>
                    <xsl:when test="($TestValue = null) or (string($TestValue) = '') or empty($TestValue)">
                        <xsl:choose>
                            <xsl:when test="$defValue = 'EMPTY'"/>
                            <xsl:when test="not(string($defValue) = '')">
                                <xsl:element name="{$TagName}">
                                    <fr_CA>
                                        <xsl:value-of select="$defValue"/>
                                    </fr_CA>
                                    <en_CA>
                                        <xsl:value-of select="$defValue"/>
                                    </en_CA>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>-->
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="{$TagName}">
               <!--<xsl:value-of select="$newValue"/>-->
               <fr_CA>
                  <xsl:for-each select="$frValue">
                     <xsl:value-of select="."/>
                     <xsl:if test="not(position() = last())"> - </xsl:if>
                  </xsl:for-each>
               </fr_CA>
               <en_CA>
                  <xsl:for-each select="$frValue">
                     <xsl:value-of select="."/>
                     <xsl:if test="not(position() = last())"> - </xsl:if>
                  </xsl:for-each>
               </en_CA>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- *************************************************************************************  -->
   <!-- Function : indexOf                                                                     -->
   <!--                                                                                        -->
   <!-- Retourne la position d'une chaine dans une liste de valeur 'tokeninze'                 -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str           = chaine de caractères à traiter                                         -->
   <!-- strSearch     = liste de valeurs 'tokenize'                                            -->
   <!-- Exemple                                                                                -->
   <!--      <xsl:variable name="table"   select="tokenize('A,B,C,D,E',',')" />                -->
   <!--      <xsl:variable name="indice"  select="index-of(. ,$list_in)" />                    -->
   <!--                                                                                        -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:indexOf">
      <xsl:param name="str"/>
      <xsl:param name="strSearch"/>
      <xsl:value-of>
         <xsl:choose>
            <xsl:when test="contains($str, $strSearch)">
               <xsl:value-of select="string-length(substring-before($str, $strSearch)) + 1"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
         </xsl:choose>
      </xsl:value-of>
   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : removeAccent                                                                -->
   <!--                                                                                        -->
   <!-- Désaccentue une chaine de caractères                                                   -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str        = chaine de caractères à traiter                                            -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:value-of select="util:removeAccent(.)"/>                                      -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:removeAccent">
      <xsl:param name="str"/>
      <xsl:value-of select="fn:normalize-unicode(fn:replace(fn:normalize-unicode($str, 'NFD'), '\p{Mn}', ''), 'NFC')"/>
   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : removeLeadingZero                                                           -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str      = chaine de caractères à traiter                                           -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:value-of select="util:removeLeadingZero(.)"/>                                 -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:removeLeadingZero">
      <xsl:param name="str"/>
      <xsl:message>
         <xsl:value-of select="$str"/>
      </xsl:message>
      <xsl:choose>
         <xsl:when test="starts-with($str, '0')">
            <xsl:value-of select="util:removeLeadingZero(substring-after($str, '0'))"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$str"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : getStringInList                                                             -->
   <!--                                                                                        -->
   <!-- Retourne la Xième sous-chaine d'une chaine délimitée                                   -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères délimitée à traiter                                 -->
   <!-- del         = delimiteur utilisé                                                       -->
   <!-- pos         = position de la sous-chaine à extraire                                    -->
   <!-- default     = valeur de défaut à retourner                                             -->
   <!--               si valeur = exception alors arrêt de traitement                          -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--       <xsl:value-of select="util:getStringInList(., '-', 2, .)"/>                      -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:getStringInList">
      <xsl:param name="str"/>
      <xsl:param name="del"/>
      <xsl:param name="pos"/>
      <xsl:param name="default"/>
      <xsl:variable name="strList" select="tokenize($str, $del)"/>
      <xsl:variable name="len" select="count($strList)"/>
      <xsl:choose>
         <xsl:when test="$len &lt; $pos">
            <xsl:choose>
               <xsl:when test="$default = 'exception'">
                  <xsl:message terminate="yes">Can't find subString</xsl:message>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$default"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$strList[number($pos)]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : getCodeMap                                                                  -->
   <!--                                                                                        -->
   <!-- Retourne la valeur correspondante selon les listes de valeurs passées en paramètre     -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractère à traiter                                            -->
   <!-- list_in     = liste des valeurs reçues                                                 -->
   <!-- list_out    = liste des valeurs à envoyer                                              -->
   <!-- default     = valeur de défaut à retourner                                             -->
   <!--               si valeur = exception alors arrêt de traitement                          -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--    	      <xsl:variable name= "table_in"    select="tokenize('1,2,3,4,5',',')"/>    -->
   <!--              <xsl:variable name= "table_out"   select="tokenize('A,B,C,D,E',',')"/>    -->
   <!--               <xsl:call-template name="stringCodeMap">                                 -->
   <!--                   <xsl:with-param name="str"        select="."/>                       -->
   <!--                   <xsl:with-param name="list_in"    select="$table_in"/>               -->
   <!--                   <xsl:with-param name="list_out"   select="$table_out"/>              -->
   <!--                   <xsl:with-param name="default"    select="'exception"/>              -->
   <!--               </xsl:call-template>                                                     -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:getCodeMap">
      <xsl:param name="str"/>
      <xsl:param name="list_in"/>
      <xsl:param name="list_out"/>
      <xsl:param name="default"/>
      <xsl:variable name="indice" select="index-of($list_in, $str)"/>
      <xsl:choose>
         <xsl:when test="$indice &gt; 0">
            <xsl:value-of select="$list_out[$indice]"/>
         </xsl:when>
         <xsl:when test="$default eq 'exception'">
            <xsl:message terminate="yes">
               <xsl:value-of select="concat('getCodeMap not found for ', $str)"/>
            </xsl:message>
         </xsl:when>
         <xsl:when test="$default eq ''">
            <xsl:value-of select="''"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$default"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : getCurrentTime                                                              -->
   <!--                                                                                        -->
   <!-- Retourne l'heure courrante                                                             -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:variable name="heure" select="util:getCurrentTime()"/>                        -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:getCurrentTime">
      <xsl:value-of select="current-time()"/>
   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : formatTime                                                                  -->
   <!--                                                                                        -->
   <!-- Transformation d'un élément de type time (heure,minute,seconce,centième de seconde)    -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères à traiter                                           -->
   <!-- format_in   = format attendu du paramètre str_in                                       -->
   <!--               où HH = heure                                                            -->
   <!--                  mm = minute                                                           -->
   <!--                  SS = seconde                                                          -->
   <!--                  ss = centième de seconde                                              -->
   <!-- format_out  = format de retour                                                         -->
   <!--               voir  https://www.w3.org/TR/xslt20/#date-picture-string                  -->
   <!-- default     = valeur de défaut à retourner                                             -->
   <!--               '' = aucune                                                              -->
   <!--               now = date et heure courrant                                             -->
   <!--               ou une formule selon le format suivante                                  -->
   <!--               [P|-P][999Y][999M][999D]T[999H][999M][999S]                              -->
   <!--               exemple: Ajoute 3 heures et 15 minutes = P3DT15M                         -->
   <!--                        Enlever 120 secondes = -PT120S                                  -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--      <xsl:value-of select="util:formatTime($str_in, $format_in, $format_out, $default)"/>  -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:formatTime">
      <xsl:param name="str"/>
      <xsl:param name="format_in"/>
      <xsl:param name="format_out"/>
      <xsl:param name="default"/>

      <xsl:variable name="time">
         <xsl:choose>
            <xsl:when test="$str != ''">
               <xsl:variable name="pH" select="util:indexOf($format_in, 'HH')"/>
               <xsl:variable name="pm" select="util:indexOf($format_in, 'mm')"/>
               <xsl:variable name="pS" select="util:indexOf($format_in, 'SS')"/>
               <xsl:variable name="ps" select="util:indexOf($format_in, 'ss')"/>

               <xsl:variable name="sH" select="substring($str, $pH, 2)"/>
               <xsl:variable name="sH">
                  <xsl:choose>
                     <xsl:when test="$sH = ''">
                        <xsl:value-of select="'00'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$sH"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="sm" select="substring($str, $pm, 2)"/>
               <xsl:variable name="sm">
                  <xsl:choose>
                     <xsl:when test="$sm = ''">
                        <xsl:value-of select="'00'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$sm"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="sS" select="substring($str, $pS, 2)"/>
               <xsl:variable name="sS">
                  <xsl:choose>
                     <xsl:when test="$sS = ''">
                        <xsl:value-of select="'00'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$sS"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="ss" select="substring($str, $ps, 2)"/>
               <xsl:variable name="ss">
                  <xsl:choose>
                     <xsl:when test="$ss = ''">
                        <xsl:value-of select="'00'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$ss"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>

               <xsl:value-of select="xs:time(concat($sH, ':', $sm, ':', $sS, '.', $ss))"/>
            </xsl:when>
            <xsl:when test="$str = '' and $default != ''">
               <xsl:value-of select="util:getCurrentTime()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="''"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:value-of>
         <xsl:choose>
            <xsl:when test="$time != ''">
               <xsl:value-of select="format-time($time, $format_out)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$str"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:value-of>
   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : getCurrentDateTime                                                          -->
   <!--                                                                                        -->
   <!-- Retourne la date et l'heure courrante                                                  -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:variable name="dhre" select="util:getCurrentDateTime()"/>                     -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:getCurrentDateTime">
      <xsl:value-of select="current-dateTime()"/>
   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : formatDateTime                                                              -->
   <!--                                                                                        -->
   <!-- Transformation d'un élément de type date et heure                                      -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- str         = chaine de caractères à traiter                                           -->
   <!-- format_in   = format attendu du paramètre str_in                                       -->
   <!--               où CC = siècle                                                           -->
   <!--                  YY = année                                                            -->
   <!--                  MM = mois                                                             -->
   <!--                  DD = jour                                                             -->
   <!--                  HH = heure                                                            -->
   <!--                  mm = minute                                                           -->
   <!--                  SS = seconde                                                          -->
   <!--                  ss = centième de seconde                                              -->
   <!-- format_out  = format de retour                                                         -->
   <!--               voir  https://www.w3.org/TR/xslt20/#date-picture-string                  -->
   <!-- default     = valeur de défaut à retourner                                             -->
   <!--               '' = aucune                                                              -->
   <!--               now = date et heure courrant                                             -->
   <!--               ou une formule selon le format suivante                                  -->
   <!--               [P|-P][999Y][999M][999D]T[999H][999M][999S]                              -->
   <!--               exemple: Ajoute 3 heures et 15 minutes = P3DT15M                         -->
   <!--                        Enlever 120 secondes = -PT120S                                  -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!--     <xsl:call-template name="dateTime">                                                -->
   <!--         <xsl:with-param name="str"        select="'20180115 1734'"/>                   -->
   <!--         <xsl:with-param name="format_in"  select="'CCYYMMDD HHMI'"/>                   -->
   <!--         <xsl:with-param name="format_out" select="'[Y0001]-[M01]-[D01] [H01]:[m01]'"/> -->
   <!--         <xsl:with-param name="default"    select="'P1D'"/>                             -->
   <!--     </xsl:call-template>                                                               -->
   <!--     ** RÉSULTAT=  2018-01-16 17:34 **                                                  -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:formatDateTime">
      <xsl:param name="str"/>
      <xsl:param name="format_in"/>
      <xsl:param name="format_out"/>
      <xsl:param name="default"/>

      <xsl:variable name="dt">
         <xsl:choose>
            <xsl:when test="$str != ''">
               <xsl:variable name="pC" select="util:indexOf($format_in, 'CC')"/>
               <xsl:variable name="pY" select="util:indexOf($format_in, 'YY')"/>
               <xsl:variable name="pM" select="util:indexOf($format_in, 'MM')"/>
               <xsl:variable name="pD" select="util:indexOf($format_in, 'DD')"/>
               <xsl:variable name="pH" select="util:indexOf($format_in, 'HH')"/>
               <xsl:variable name="pm" select="util:indexOf($format_in, 'mm')"/>
               <xsl:variable name="pS" select="util:indexOf($format_in, 'SS')"/>
               <xsl:variable name="ps" select="util:indexOf($format_in, 'ss')"/>
               <xsl:variable name="sC" select="substring($str, $pC, 2)"/>
               <xsl:variable name="sC">
                  <xsl:choose>
                     <xsl:when test="$sC = ''">
                        <xsl:value-of select="'20'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$sC"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="sY" select="substring($str, $pY, 2)"/>
               <xsl:variable name="sM" select="substring($str, $pM, 2)"/>
               <xsl:variable name="sD" select="substring($str, $pD, 2)"/>

               <xsl:variable name="sH">
                  <xsl:choose>
                     <xsl:when test="$pH = '0'">
                        <xsl:value-of select="'00'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring($str, $pH, 2)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="sm">
                  <xsl:choose>
                     <xsl:when test="$pm = '0'">
                        <xsl:value-of select="'00'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring($str, $pm, 2)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="sS">
                  <xsl:choose>
                     <xsl:when test="$pS = '0'">
                        <xsl:value-of select="'00'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring($str, $pS, 2)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:variable name="ss">
                  <xsl:choose>
                     <xsl:when test="$ps = '0'">
                        <xsl:value-of select="'00'"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="substring($str, $ps, 2)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:value-of select="xs:dateTime(concat($sC, $sY, '-', $sM, '-', $sD, 'T', $sH, ':', $sm, ':', $sS, '.', $ss))"/>
            </xsl:when>
            <xsl:when test="$str = '' and $default != ''">
               <xsl:value-of select="util:getCurrentDateTime()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="''"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="dt">
         <xsl:choose>
            <xsl:when test="$dt != '' and (starts-with($default, 'P') or starts-with($default, '-P'))">
               <xsl:value-of select="xs:dateTime($dt) + xs:dayTimeDuration($default)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$dt"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:value-of>
         <xsl:choose>
            <xsl:when test="$dt != ''">
               <xsl:value-of select="format-dateTime($dt, $format_out)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$str"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:value-of>

   </xsl:function>


   <!-- *************************************************************************************  -->
   <!-- Function : getDuration                                                                 -->
   <!--                                                                                        -->
   <!-- Calcul la durée entre deux dates                                                       -->
   <!--                                                                                        -->
   <!-- Paramètres:                                                                            -->
   <!-- dtStart     = date de début                                                            -->
   <!-- dtEnd       = date de fin                                                              -->
   <!-- format_out  = où [D] la durée totale en jour                                           -->
   <!--                  [H] la durée totale en heure                                          -->
   <!--                  [M] la durée totale en minute                                         -->
   <!--                  [S] la durée totale en seconde                                        -->
   <!--                  [h] le reste de la durée en heure                                     -->
   <!--                  [m] le reste de la durée en minute                                    -->
   <!--                  [s] le reste de la durée en seconde                                   -->
   <!--                                                                                        -->
   <!-- Exemple                                                                                -->
   <!-- *************************************************************************************  -->
   <xsl:function name="util:getDuration">
      <xsl:param name="dtStart"/>
      <xsl:param name="dtEnd"/>
      <xsl:param name="format_out"/>
      <!-- D -->
      <xsl:variable name="period" select="xs:dateTime($dtEnd) - xs:dateTime($dtStart)"/>
      <xsl:variable name="duration" select="xs:dayTimeDuration($period)"/>

      <xsl:variable name="hours" select="hours-from-duration($duration)"/>
      <xsl:variable name="minutes" select="minutes-from-duration($duration)"/>
      <xsl:variable name="seconds" select="seconds-from-duration($duration)"/>

      <xsl:variable name="daysT" select="days-from-duration($duration)"/>
      <xsl:variable name="hoursT" select="($daysT * 24) + $hours"/>
      <xsl:variable name="minutesT" select="($daysT * 24 * 60) + ($hours * 60) + $minutes"/>
      <xsl:variable name="secondsT" select="($daysT * 24 * 60 * 60) + ($hours * 60 * 60) + ($minutes * 60) + $seconds"/>

      <xsl:value-of
         select="replace(replace(replace(replace(replace(replace(replace($format_out, '[D]', string($daysT)), '[H]', string($hoursT)), '[M]', string($minutesT)), '[S]', string($secondsT)), '[h]', string($hours)), '[m]', string($minutes)), '[s]', string($seconds))"/>

   </xsl:function>

</xsl:stylesheet>
