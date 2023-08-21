
<!-- 
	No. Date       User     Description / commentaires (Optionnel)
	+++ ++++++++++ ++++++++ +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
	1   2022-08-18 TC   Création GGPS
	2   2021-04-20 EG   Version normée avec l'équipe de développement
-->

<xsl:stylesheet xmlns:exsl="http://exslt.org/common"
   
   xmlns:functx="http://www.functx.com"
   xmlns:util="http://whatever"
   xmlns:xp="http://www.w3.org/2005/xpath-functions"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   
   exclude-result-prefixes="#all"
   extension-element-prefixes="exsl"
   version="3.0">
   <!-- Inclusion du xsl de base -->
   <xsl:import href="Eclinibase ADT Winvision.xsl"/>
   
   <!-- ************************************************************************************************************************* -->
   <!--                                                          XSL PERSO                                                        -->
   <!-- ************************************************************************************************************************* -->
   <!-- options, format de sortie -->
   <xsl:strip-space elements="*"/>
   <xsl:output omit-xml-declaration="yes" indent="yes" encoding="UTF-8" method="xml" version="1.0"/>
  
   <xsl:template match="/">
      <xsl:element name="HL7">
         <xsl:call-template name="MSH"/>
         <xsl:call-template name="EVN"/>  
         <xsl:call-template name="PID"/>
         <xsl:call-template name="NK1"/>
     
         <!-- si 48 on enleve des segments -->
         <xsl:choose>
            <xsl:when test="not($messageType = 'A48')">
            <xsl:call-template name="PV1"/>
            </xsl:when>     
         </xsl:choose>
         
         <xsl:choose>
            <xsl:when test="not(($messageType = 'A48' and $eventCode = '215') or $messageType='A08' or $messageType='A01' or $messageType='A02')">
               <xsl:call-template name="MRG"/>
            </xsl:when> 
         </xsl:choose>
           
         <xsl:call-template name="ZPV"/>  
      </xsl:element>
   </xsl:template>
  
   <xsl:template name="MSH">
      <xsl:element name="MSH">
         <xsl:call-template name="MSH.1"/> -->
         <xsl:call-template name="MSH.2"/>
         <xsl:call-template name="MSH.3"/>
         <xsl:call-template name="MSH.4"/> 
         <xsl:call-template name="MSH.5"/> 
         <xsl:call-template name="MSH.6"/>
         <xsl:call-template name="MSH.7"/>
         <xsl:call-template name="MSH.9"/>
         <xsl:call-template name="MSH.10"/>
         <xsl:call-template name="MSH.11"/>
         <xsl:call-template name="MSH.12"/>
         <xsl:call-template name="MSH.15"/>
         <xsl:call-template name="MSH.16"/>
         <xsl:call-template name="MSH.17"/>
         <xsl:call-template name="MSH.19"/>
      </xsl:element>
   </xsl:template> 
   
   <!-- Sending facility -->
   <xsl:template name="MSH.4">
      <xsl:element name="MSH.4.1">
         <xsl:value-of select="'HMR'"/>
      </xsl:element>
      
      <xsl:element name="MSH.4.2">
         <xsl:value-of select="'12934659'"/>
      </xsl:element>       
   </xsl:template>  
   
   <xsl:template name="MSH.5">
      <xsl:element name="MSH.5.1">
         <xsl:value-of select="'HMR_DIETETIQUE_HL7'"/>
      </xsl:element> 
   </xsl:template> 
   
   <xsl:template name="MSH.6">
      <xsl:element name="MSH.6.1">
         <xsl:value-of select="'HMR'"/>
      </xsl:element> 
   </xsl:template> 
   
   <xsl:template name="MSH.15">
      <xsl:element name="MSH.15.1">
         <xsl:value-of select="'NE'"/>
      </xsl:element> 
   </xsl:template> 
   
   <xsl:template name="MSH.16">
      <xsl:element name="MSH.16.1">
         <xsl:value-of select="'NE'"/>
      </xsl:element> 
   </xsl:template> 
   
   <xsl:template name="MSH.17">
      <xsl:element name="MSH.17.1">
         <xsl:value-of select="'CAN'"/>
      </xsl:element> 
   </xsl:template>
   
   <xsl:template name="MSH.19">
      <xsl:element name="MSH.19.1">
         <xsl:value-of select="'FR'"/>
      </xsl:element>
 
      <xsl:element name="MSH.19.2">
         <xsl:value-of select="'Francais'"/>
      </xsl:element>
   </xsl:template>
  
   <xsl:template name="PV1">
      <xsl:element name="PV1">
         <xsl:element name="PV1.1.1">
            <xsl:value-of select="substring(/HL7/PV1/PV1.1.1,4,4)"/>
         </xsl:element>
         
         <xsl:element name="PV1.2.1">
            <xsl:value-of select="/HL7/PV1/PV1.2.1"/>
         </xsl:element>
         
         <xsl:variable name="unitSoins">
         <xsl:choose> 
            <xsl:when test="($messageType != 'A12')"> 
               <xsl:value-of select="/HL7/PV1/PV1.3.1"/>
            </xsl:when>   
            
            <xsl:otherwise> 
               <xsl:value-of select="/HL7/PV1/PV1.6.1"/>
            </xsl:otherwise>    
         </xsl:choose>
      </xsl:variable>  
        
         <xsl:element name="PV1.3.1">
            <xsl:choose> 
               <xsl:when test= "$unitSoins = 'M10A'">  
                    <xsl:value-of select="'M10A&amp;M10AB'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M10C'">  
                  <xsl:value-of select="'M10C&amp;Gériatrie'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M10S'">  
                  <xsl:value-of select="'M10S&amp;M10 COURT-SÉJOUR'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M1CA'">  
                  <xsl:value-of select="'M1CA&amp;Chirurgie CSA'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M2C'">  
                  <xsl:value-of select="'M2C&amp;UNITE CORONARIENNE'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M2HO'">  
                  <xsl:value-of select="'M2HO&amp;CSA 2e ETAGE'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M2JO'">  
                  <xsl:value-of select="'M2JO&amp;CSA 2 ÉTAGE'"/> 
               </xsl:when>  
               
               <xsl:when test= "$unitSoins = 'M2S'">  
                  <xsl:value-of select="'M2S&amp;Soins intensifs'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'MUDC'">  
                  <xsl:value-of select="'MUDC&amp;Unité brève hospit'"/> 
               </xsl:when>  
               
               <xsl:when test= "$unitSoins = 'M3C'">  
                  <xsl:value-of select="'M3C&amp;M3C'"/> 
               </xsl:when>                

               <xsl:when test= "$unitSoins = 'M4AB'">  
                  <xsl:value-of select="'M4AB&amp;M4AB'"/> 
               </xsl:when> 

               <xsl:when test= "$unitSoins = 'M4CD'">  
                  <xsl:value-of select="'M4CD&amp;M4CD'"/> 
               </xsl:when> 
 
               <xsl:when test= "$unitSoins = 'M5AB'">  
                  <xsl:value-of select="'M5AB&amp;M5AB'"/> 
               </xsl:when> 
               
               <xsl:when test= "$unitSoins = 'M5CD'">  
                  <xsl:value-of select="'M5CD&amp;M5CD'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M5A'">  
                  <xsl:value-of select="'M5A&amp;M5A'"/> 
               </xsl:when>              

               <xsl:when test= "$unitSoins = 'M5BC'">  
                  <xsl:value-of select="'M5BC&amp;M5BC'"/> 
               </xsl:when> 
               
               <xsl:when test= "$unitSoins = 'M6AB'">  
                  <xsl:value-of select="'M6AB&amp;M6AB'"/> 
               </xsl:when>              

               <xsl:when test= "$unitSoins = 'M6CD'">  
                  <xsl:value-of select="'M6CD&amp;M6CD'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M6CS'">  
                  <xsl:value-of select="'M6CS&amp;M6CS COURT-SÉJOUR'"/> 
               </xsl:when>             
  
               <xsl:when test= "$unitSoins = 'M6GR'">  
                  <xsl:value-of select="'M6GR&amp;UNITE GREFFE RENALE'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M7AB'">  
                  <xsl:value-of select="'M7AB&amp;M7AB'"/> 
               </xsl:when>  
  
               <xsl:when test= "$unitSoins = 'M7C'">  
                  <xsl:value-of select="'M7C&amp;SALLE D&quot;ACCOUCHEMENT'"/> 
               </xsl:when>  
               
               <xsl:when test= "$unitSoins = 'M7D'">  
                  <xsl:value-of select="'M7D&amp;M7D POUP.'"/> 
               </xsl:when>  
               
               <xsl:when test= "$unitSoins = 'M7PG'">  
                  <xsl:value-of select="'M7PG&amp;Pouponière Générale'"/> 
               </xsl:when>  
               
               <xsl:when test= "$unitSoins = 'M8AB'">  
                  <xsl:value-of select="'M8AB&amp;M8AB'"/> 
               </xsl:when>  
               
               <xsl:when test= "$unitSoins = 'M8CD'">  
                  <xsl:value-of select="'M8CD&amp;M8CD PEDIATRIE'"/> 
               </xsl:when> 
               
               <xsl:when test= "$unitSoins = 'M8JO'">  
                  <xsl:value-of select="'M8JO&amp;SOINS D&quot;UN JOUR'"/> 
               </xsl:when>    
 
               <xsl:when test= "$unitSoins = 'M8PS'">  
                  <xsl:value-of select="'M8PS&amp;SOINS INT. PEDIATRIE'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'M9AB'">  
                  <xsl:value-of select="'M9AB&amp;M9AB'"/> 
               </xsl:when> 
               
               <xsl:when test= "$unitSoins = 'M9CD'">  
                  <xsl:value-of select="'M9AB&amp;M9AB'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'MUHT'">  
                  <xsl:value-of select="'MUHT&amp;Hospit. transitoire'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'MJO'">  
                  <xsl:value-of select="'MJO&amp;Medecine je jour-urg'"/> 
               </xsl:when>             
               
               <xsl:when test= "$unitSoins = 'R1C'">  
                  <xsl:value-of select="'R1C&amp;1er ETAGE AILE C'"/> 
               </xsl:when>             
               
               <xsl:when test= "$unitSoins = 'R1CA'">  
                  <xsl:value-of select="'R1CA&amp;Chirugie ambulatoire'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'R1JO'">  
                  <xsl:value-of select="'R1JO&amp;SOINS-1-JR'"/> 
               </xsl:when>   
               
               <xsl:when test= "$unitSoins = 'R2A'">  
                  <xsl:value-of select="'R2A&amp;Rosemont 2ième A'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'R2C'">  
                  <xsl:value-of select="'R2C&amp;2 ieme C PSYCHIATRIE'"/> 
               </xsl:when>   
               
               <xsl:when test= "$unitSoins = 'R2CI'">  
                  <xsl:value-of select="'R2CI&amp;SOINS INTERM. PSY'"/> 
               </xsl:when> 
               
               <xsl:when test= "$unitSoins = 'R4A'">  
                  <xsl:value-of select="'R4A&amp;4A courte durée'"/> 
               </xsl:when>   
               
               <xsl:when test= "$unitSoins = 'H31'">  
                  <xsl:value-of select="'H31&amp;SalleH31 Onco'"/> 
               </xsl:when>   
               
               <xsl:when test= "$unitSoins = 'URG'">  
                  <xsl:value-of select="'URG&amp;Urgence'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'MPHY'">  
                  <xsl:value-of select="'MPHY&amp;MPHY-Aile Physio'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'MSR'">  
                  <xsl:value-of select="'MSR&amp;MSR-Salle réveil'"/> 
               </xsl:when>  
               
               <xsl:when test= "$unitSoins = 'MUPP'">  
                  <xsl:value-of select="'MUPP&amp;MUPP-Unité pré-opératoire'"/> 
               </xsl:when>
               
               <xsl:when test= "$unitSoins = 'CMS'">  
                  <xsl:value-of select="'CMS&amp;CMS-Clin. méd. spécialisée'"/> 
               </xsl:when>
               
               <xsl:otherwise>  
                  <xsl:value-of select="concat($unitSoins,'&amp;','Description non définie')"/> 
               </xsl:otherwise> 
            </xsl:choose>
         </xsl:element> 
         
         <xsl:variable name="roomPatient" select="/HL7/PV1/PV1.3.2" />
         <xsl:variable name="roomPavillon" select="substring($roomPatient,1,1)" />
         
         <xsl:element name="PV1.3.2">         
            <xsl:choose>        
               <xsl:when test="$roomPatient = 'M01090'">
                  <xsl:value-of select="'M 1090'"/>
            </xsl:when>
               
               <xsl:when test="$roomPatient = 'M01080'">
                  <xsl:value-of select="'M 1080'"/>
           </xsl:when>
               
               <xsl:when test="$roomPatient = 'M00990'">
                  <xsl:value-of select="'M 0990'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00980'">
                  <xsl:value-of select="'M 0980'"/>
           </xsl:when>
               
               <xsl:when test="$roomPatient = 'M00780'">
                 <xsl:value-of select="'M 0780'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00690'">
                 <xsl:value-of select="'M 0690'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00680'">
                <xsl:value-of select="'M 0680'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00580'">
                <xsl:value-of select="'M 0580'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00490'">
                <xsl:value-of select="'M 0490'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00480'">
                <xsl:value-of select="'M 0480'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient= 'M00470'">
                  <xsl:value-of select="'M 0480'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00380'">
                <xsl:value-of select="'M 0470'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00470'">
                <xsl:value-of select="'M 0470'"/>
           </xsl:when> 
                
               <xsl:when test="$roomPatient = 'M00180'">
                <xsl:value-of select="'M 0180'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00638'">
                <xsl:value-of select="'M 0638'"/>
           </xsl:when> 
               
               <xsl:when test="$roomPatient = 'M00653'">
                <xsl:value-of select="'M 0653'"/>
           </xsl:when> 
               
            <xsl:otherwise>
               <xsl:value-of select="concat(concat($roomPavillon,' '), substring($roomPatient,2))"/> 
            </xsl:otherwise>
            </xsl:choose>         
         </xsl:element>
         
         <xsl:element name="PV1.3.3">
            <xsl:value-of select="substring-after(/HL7/PV1/PV1.3.3,'-')"/> 
         </xsl:element>
         
         <xsl:element name="PV1.3.4">
            <xsl:value-of select="concat(/HL7/MSH/MSH.4.1,'&amp;','Maisonneuve-Rosemont')"/> 
         </xsl:element>       
         
         <xsl:element name="PV1.3.7">
            <xsl:choose>
               <xsl:when test="$roomPavillon ='M'">  
                   <xsl:value-of select="concat('MA','&amp;','Pavillon Maisonneuve')"/> 
               </xsl:when>
               
               <xsl:when test="$roomPavillon ='R'">  
                  <xsl:value-of select="concat('MA','&amp;','Pavillon Rosemont')"/> 
               </xsl:when>
               
               <xsl:otherwise>  
                  <xsl:value-of select="concat('AU','&amp;','Pavillon Autre')"/> 
               </xsl:otherwise> 
            </xsl:choose>
         </xsl:element>   
         
         <xsl:element name="PV1.4.1">
            <xsl:value-of select="/HL7/PV1/PV1.18.1"/> 
         </xsl:element>
         
         <xsl:element name="PV1.7.1">
            <xsl:value-of select="/HL7/PV1/PV1.7.1"/> 
         </xsl:element>
         
         <xsl:element name="PV1.7.2">
            <xsl:value-of select="substring-before(/HL7/PV1/PV1.7.2,',')"/> 
         </xsl:element>
         
         <xsl:element name="PV1.7.3">
            <xsl:value-of select="substring-after(/HL7/PV1/PV1.7.2,',')"/> 
         </xsl:element>
         
         <xsl:element name="PV1.7.7">
            <xsl:value-of select="'MD'"/> 
         </xsl:element>
         
         <xsl:variable name="hospitalService" select="/HL7/PV1/PV1.10.1" />
        
         <xsl:element name="PV1.10.1">
            <xsl:choose>
               <xsl:when test="$hospitalService ='CAR'">  
                  <xsl:value-of select="'2'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='DER'">  
                  <xsl:value-of select="'3'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='END'">  
                  <xsl:value-of select="'4'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='GAS'">  
                  <xsl:value-of select="'5'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='HEM'">  
                  <xsl:value-of select="'6'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='INT'">  
                  <xsl:value-of select="'7'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='NEP'">  
                  <xsl:value-of select="'8'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='NEU'">  
                  <xsl:value-of select="'9'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='PHYS'">  
                  <xsl:value-of select="'10'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='PNE'">  
                  <xsl:value-of select="'11'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='RHU'">  
                  <xsl:value-of select="'12'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='CVT'">  
                  <xsl:value-of select="'20'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='BUC'">  
                  <xsl:value-of select="'22'"/> 
               </xsl:when>   
               
               <xsl:when test="$hospitalService ='CHI'">  
                  <xsl:value-of select="'24'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='ONCH'">  
                  <xsl:value-of select="'24'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='PCHI'">  
                  <xsl:value-of select="'24'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='PLA'">  
                  <xsl:value-of select="'26'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='CHT'">  
                  <xsl:value-of select="'28'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='NECH'">  
                  <xsl:value-of select="'30'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='OPH'">  
                  <xsl:value-of select="'32'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='ORT'">  
                  <xsl:value-of select="'34'"/> 
               </xsl:when>   
               
               <xsl:when test="$hospitalService ='ORL'">  
                  <xsl:value-of select="'36'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='URO'">  
                  <xsl:value-of select="'38'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='ARE'">  
                  <xsl:value-of select="'50'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='SCO'">  
                  <xsl:value-of select="'59'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='GYN'">  
                  <xsl:value-of select="'60'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='GYON'">  
                  <xsl:value-of select="'60'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='OBS'">  
                  <xsl:value-of select="'66'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='OGY'">  
                  <xsl:value-of select="'66'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='APA'">  
                  <xsl:value-of select="'70'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='MIM'">  
                  <xsl:value-of select="'73'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='RAD'">  
                  <xsl:value-of select="'76'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='RON'">  
                  <xsl:value-of select="'77'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='NUC'">  
                  <xsl:value-of select="'78'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='PED'">  
                  <xsl:value-of select="'80'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='NEO'">  
                  <xsl:value-of select="'81'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='SPAL'">  
                  <xsl:value-of select="'83'"/> 
               </xsl:when>   
               
               <xsl:when test="$hospitalService ='HSP'">  
                  <xsl:value-of select="'84'"/> 
               </xsl:when>    
               
               <xsl:when test="$hospitalService ='MED'">  
                  <xsl:value-of select="'85'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='PMED'">  
                  <xsl:value-of select="'85'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='MURG'">  
                  <xsl:value-of select="'85'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='URG'">  
                  <xsl:value-of select="'85'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='MFAM'">  
                  <xsl:value-of select="'85'"/> 
               </xsl:when>   
               
               <xsl:when test="$hospitalService ='SPRO'">  
                  <xsl:value-of select="'85'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='ONC'">  
                  <xsl:value-of select="'87'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='GER'">  
                  <xsl:value-of select="'89'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='PSY'">  
                  <xsl:value-of select="'90'"/> 
               </xsl:when>    
               
               <xsl:otherwise>  
                  <xsl:value-of select="'0'"/> 
               </xsl:otherwise> 
            </xsl:choose>   
         </xsl:element>  
         
         <xsl:element name="PV1.10.2">
            <xsl:choose>
               <xsl:when test="$hospitalService ='CAR'">  
                  <xsl:value-of select="'CARDIOLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='DER'">  
                  <xsl:value-of select="'DERMATOLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='END'">  
                  <xsl:value-of select="'ENDOCRINOLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='GAS'">  
                  <xsl:value-of select="'GASTRO-ENTÉROLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='HEM'">  
                  <xsl:value-of select="'HÉMATOLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='INT'">  
                  <xsl:value-of select="'MÉDECINE INTERNE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='NEP'">  
                  <xsl:value-of select="'NÉPHROLOGIE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='NEU'">  
                  <xsl:value-of select="'NEUROLOGIE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='PHYS'">  
                  <xsl:value-of select="'PHYSIATRIE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='PNE'">  
                  <xsl:value-of select="'PNEUMOLOGIE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='RHU'">  
                  <xsl:value-of select="'RHUMATOLOGIE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='CVT'">  
                  <xsl:value-of select="'CHIRURGIE VASCULAIRE ET THORACIQUE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='BUC'">  
                  <xsl:value-of select="'CHIRURGIE BUCCALE'"/> 
               </xsl:when>   
               
               <xsl:when test="$hospitalService ='CHI'">  
                  <xsl:value-of select="'CHIRURGIE GÉNÉRALE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='ONCH'">  
                  <xsl:value-of select="'ONCO-CHIRURGIE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='PCHI'">  
                  <xsl:value-of select="'POLYVALENTS DE CHIRURGIE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='PLA'">  
                  <xsl:value-of select="'CHIRURGIE PLASTIQUE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='CHT'">  
                  <xsl:value-of select="'CHIRURGIE THORACIQUE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='NECH'">  
                  <xsl:value-of select="'NEUROCHIRURGIE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='OPH'">  
                  <xsl:value-of select="'OPHTALMOLOGIE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='ORT'">  
                  <xsl:value-of select="'ORTHOPÉDIE'"/> 
               </xsl:when>   
               
               <xsl:when test="$hospitalService ='ORL'">  
                  <xsl:value-of select="'OTO-RHINO-LARYNGOLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='URO'">  
                  <xsl:value-of select="'UROLOGIE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='ARE'">  
                  <xsl:value-of select="'ANESTHÉSIE-RÉANIMATION'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='SCO'">  
                  <xsl:value-of select="'SANTÉ COMMUNAUTAIRE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='GYN'">  
                  <xsl:value-of select="'GYNÉCOLOGIE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='GYON'">  
                  <xsl:value-of select="'GYNÉCOLOGIE-ONCOLOGIQUE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='OBS'">  
                  <xsl:value-of select="'OBSTÉTRIQUE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='OGY'">  
                  <xsl:value-of select="'OBSTÉTRIQUE GYNÉCOLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='APA'">  
                  <xsl:value-of select="'ANATOMOPATHOLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='MIM'">  
                  <xsl:value-of select="'MICROBIOLOGIE MÉDICALE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='RAD'">  
                  <xsl:value-of select="'RADIOLOGIE DIAGNOSTIQUE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='RON'">  
                  <xsl:value-of select="'RADIO-ONCOLOGIE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='NUC'">  
                  <xsl:value-of select="'MÉDECINE NUCLÉAIRE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='PED'">  
                  <xsl:value-of select="'PÉDIATRIE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='NEO'">  
                  <xsl:value-of select="'NÉONATALOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='SPAL'">  
                  <xsl:value-of select="'SOINS PALLIATIFS'"/> 
               </xsl:when>   
               
               <xsl:when test="$hospitalService ='HSP'">  
                  <xsl:value-of select="'HYGIÈNE ET SANTÉ PUBLIQUE'"/> 
               </xsl:when>    
               
               <xsl:when test="$hospitalService ='MED'">  
                  <xsl:value-of select="'OMNIPRATICIEN'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='PMED'">  
                  <xsl:value-of select="'POLYVALENTS DE MÉDECINE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='MURG'">  
                  <xsl:value-of select="'MÉDECINE D&quot;URGENCE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='URG'">  
                  <xsl:value-of select="'MÉDECINE D&quot;URGENCE'"/> 
               </xsl:when> 
               
               <xsl:when test="$hospitalService ='MFAM'">  
                  <xsl:value-of select="'MÉDECINE FAMILIALE'"/> 
               </xsl:when>   
               
               <xsl:when test="$hospitalService ='SPRO'">  
                  <xsl:value-of select="'SOINS PROLONGÉS'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='ONC'">  
                  <xsl:value-of select="'ONCOLOGIE'"/> 
               </xsl:when>
               
               <xsl:when test="$hospitalService ='GER'">  
                  <xsl:value-of select="'GÉRIATRIE'"/> 
               </xsl:when>  
               
               <xsl:when test="$hospitalService ='PSY'">  
                  <xsl:value-of select="'PSYCHIATRIE'"/> 
               </xsl:when>    
               
               <xsl:otherwise>  
                  <xsl:value-of select="'Spécialité inconnue'"/> 
               </xsl:otherwise> 
            </xsl:choose>   
         </xsl:element>  
         
         <xsl:variable name="admissionType" select="/HL7/PV1/PV1.4.1" />
         
         <xsl:element name="PV1.14.1">  
         <xsl:choose>
            
            <xsl:when test="$admissionType ='1'">  
               <xsl:value-of select="'10'"/> 
            </xsl:when>
            
            <xsl:when test="$admissionType ='2'">  
               <xsl:value-of select="'21'"/> 
            </xsl:when>
            
            <xsl:when test="$admissionType ='3'">  
               <xsl:value-of select="'30'"/> 
            </xsl:when>
            
            <xsl:when test="$admissionType ='4'">  
               <xsl:value-of select="'40'"/> 
            </xsl:when>
            
            <xsl:when test="$admissionType ='5'">  
               <xsl:value-of select="'50'"/> 
            </xsl:when>  
            
            <xsl:when test="$admissionType ='6'">  
               <xsl:value-of select="'60'"/> 
            </xsl:when>  
            
            <xsl:when test="$admissionType ='7'">  
               <xsl:value-of select="'70'"/> 
            </xsl:when>    
            
            <xsl:when test="$admissionType ='8'">  
               <xsl:value-of select="'80'"/> 
            </xsl:when>  
            
            <xsl:when test="$admissionType ='9'">  
               <xsl:value-of select="'90'"/> 
            </xsl:when>      
         </xsl:choose>
         </xsl:element> 
   
         <xsl:element name="PV1.14.2">  
            <xsl:choose>
               
               <xsl:when test="$admissionType ='1'">  
                  <xsl:value-of select="'ADMISSION URGENTE'"/> 
               </xsl:when>
               
               <xsl:when test="$admissionType ='2'">  
                  <xsl:value-of select="'SEMI-URG. ELECTIVE'"/> 
               </xsl:when>
               
               <xsl:when test="$admissionType ='3'">  
                  <xsl:value-of select="'ADM. NON-URGENTE'"/> 
               </xsl:when>
               
               <xsl:when test="$admissionType ='4'">  
                  <xsl:value-of select="'ADM. OBSTÉTRIQUE'"/> 
               </xsl:when>
               
               <xsl:when test="$admissionType ='5'">  
                  <xsl:value-of select="'AD,. NOUVEAU-NE'"/> 
               </xsl:when>  
               
               <xsl:when test="$admissionType ='6'">  
                  <xsl:value-of select="'INSC. SOUN D&quot;UN JOUR'"/> 
               </xsl:when>  
               
               <xsl:when test="$admissionType ='7'">  
                  <xsl:value-of select="'ADM. ENVOI POUR EXAMEN'"/> 
               </xsl:when>    
               
               <xsl:when test="$admissionType ='8'">  
                  <xsl:value-of select="'ADM. ENVOI POUR ÉVALUATION'"/> 
               </xsl:when>  
               
               <xsl:when test="$admissionType ='9'">  
                  <xsl:value-of select="'ADM. JUDICIAIRE'"/> 
               </xsl:when>      
            </xsl:choose>
         </xsl:element> 
         
         <xsl:element name="PV1.16.1">
            <xsl:value-of select="'0'"/> 
         </xsl:element> 
            
         <xsl:element name="PV1.17.1">
            <xsl:value-of select="/HL7/PV1/PV1.7.1"/> 
         </xsl:element> 
         
         <xsl:element name="PV1.17.2">
         <xsl:value-of select="substring-before(/HL7/PV1/PV1.7.2,',')"/> 
      </xsl:element> 
      
      <xsl:element name="PV1.17.3">
           <xsl:value-of select="substring-after(/HL7/PV1/PV1.7.2,',')"/> 
      </xsl:element> 
         
      <xsl:element name="PV1.17.7">
           <xsl:value-of select="'MD'"/> 
      </xsl:element> 
         
      <xsl:variable name="patientType" select="/HL7/PV1/PV1.18.1" />
         
         <xsl:element name="PV1.18.1">   
         <xsl:choose>
            
            <xsl:when test="$patientType ='1'">  
               <xsl:value-of select="'CD'"/> 
            </xsl:when>
            
            <xsl:when test="$patientType ='3'">  
               <xsl:value-of select="'LD'"/> 
            </xsl:when>  
            
            <xsl:when test="$patientType ='27'">  
               <xsl:value-of select="'JO'"/> 
            </xsl:when>       
         </xsl:choose>
      </xsl:element> 
         
         <xsl:element name="PV1.18.2">   
            <xsl:choose>
               
               <xsl:when test="$patientType ='1'">  
                  <xsl:value-of select="'Soins de courte duree'"/> 
               </xsl:when>
               
               <xsl:when test="$patientType ='3'">  
                  <xsl:value-of select="'Soins de longue duree'"/> 
               </xsl:when>  
               
               <xsl:when test="$patientType ='27'">  
                  <xsl:value-of select="'Soins en chirurgie d&quot;un jour'"/> 
               </xsl:when>       
            </xsl:choose>
         </xsl:element> 
         
         <xsl:element name="PV1.19.1">   
            <xsl:value-of select="/HL7/PV1/PV1.19.1"/> 
         </xsl:element> 
  
         <xsl:element name="PV1.20.1">   
            <xsl:value-of select="/HL7/PV1/PV1.20.1"/> 
         </xsl:element> 
         
         <xsl:element name="PV1.44.1">   
            <xsl:value-of select="/HL7/PV1/PV1.44.1"/> 
         </xsl:element>
      </xsl:element> 
      
      <xsl:variable name="diagnosisSegment" select="/HL7/DG1/DG1.3.2" />
      
      <xsl:if test="($diagnosisSegment != '')"> 
      <xsl:element name="PV2">
          <xsl:element name="PV2.1.1">
             <xsl:value-of select="substring(/HL7/PV2/PV2.1.1,4,4)"/>
          </xsl:element>
          
          <xsl:element name="PV2.3.1">
             <xsl:value-of select="$diagnosisSegment"/>
          </xsl:element> 
      </xsl:element>
     </xsl:if> 
   </xsl:template>
   
   <xsl:variable name="mergePatientInformation" select="/HL7/MRG/MRG.2.1" />
   
   <xsl:template name="MRG">
      <xsl:if test="($mergePatientInformation != '')"> 
      <xsl:element name="MRG"> 
         <xsl:element name="MRG.1.1">
            <xsl:value-of select="$mergePatientInformation"/>
         </xsl:element>
         
         <xsl:element name="MRG.1.4.1">
            <xsl:value-of select="'HMR'"/>
         </xsl:element>
      </xsl:element>
    </xsl:if> 
   </xsl:template>
    
   <xsl:variable name="citizenship" select="/HL7/PID/PID.26.1" />
   
   <xsl:template name="ZPV">
      <xsl:element name="ZPV">
         
      <xsl:element name="ZPV.2.1">
         <xsl:choose>
              <xsl:when test="($citizenship = '')"> 
              <xsl:value-of select="'0'"/>
              </xsl:when> 
            
            <xsl:when test="($citizenship = '2')"> 
               <xsl:value-of select="'2'"/>
            </xsl:when> 
         </xsl:choose>
      </xsl:element>
      
      <xsl:element name="ZPV.2.2">
         <xsl:choose>
            <xsl:when test="($citizenship = '')"> 
             <xsl:value-of select="'CANADA'"/>
            </xsl:when> 
            
            <xsl:when test="($citizenship = '2')"> 
               <xsl:value-of select="'IMMIGRANT RECU'"/>
            </xsl:when> 
         </xsl:choose>
      </xsl:element>     
      
      <xsl:element name="ZPV.4.1">
            <xsl:value-of select="/HL7/ZV1/ZV1.22.1"/> 
      </xsl:element>
      
      <xsl:element name="ZPV.11.1">
         <xsl:value-of select="/HL7/ZV1/ZV1.2.1"/> 
      </xsl:element>
      
      <xsl:element name="ZPV.11.2">
         <xsl:value-of select="/HL7/ZV1/ZV1.3.1"/> 
      </xsl:element>
         
      </xsl:element>
   </xsl:template>
   
</xsl:stylesheet>

