
   <!-- 
	No. Date       User     Description / commentaires (Optionnel)
	+++ ++++++++++ ++++++++ +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
	1   2018-09-26 lajrob   
-->
   <xsl:stylesheet xmlns:exsl="http://exslt.org/common"
                   xmlns:fn="http://www.w3.org/2005/xpath-functions"
                   xmlns:xs="http://www.w3.org/2001/XMLSchema"
                   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                   exclude-result-prefixes="#all"
                   extension-element-prefixes="exsl"
                   version="3.0">
      <!-- options, format de sortie -->
      <xsl:strip-space elements="*"/>
      <xsl:output encoding="UTF-8"
                  indent="yes"
                  method="xml"
                  omit-xml-declaration="yes"
                  version="1.0"/>
      
      <!-- Inclusion des Templates  -->
      <xsl:include href="util-Templates.xsl"/>
      <!-- déclaration des paramètres -->
      <xsl:param name="varParam1"/>
      <xsl:param name="varParam2"/>
      <xsl:param name="varParam3"/>
      <xsl:param name="varParam4"/>
      <xsl:param name="varParam5"/>
      <xsl:param name="varParam6"/>
      <xsl:param name="varParam7"/>
      <xsl:param name="varParam8"/>
      <xsl:param name="varParam9"/>
      
      <!-- votre code ici -->
      <!-- this is the identity transform: it copies everything that isn't matched by a more specific template -->
      <!-- recopie de tous les élements (node=balise, @=attribut) -->
      
      <!--      <xsl:template match="/">
         <xsl:element name="HL7">
            <xsl:call-template name="MSH"/>
            <xsl:call-template name="EVN"/>  
            <xsl:call-template name="PID"/>
            <xsl:call-template name="NK1"/>
      </xsl:template> --> 
      
      <xsl:template name="MSH">
         <xsl:element name="MSH">
         </xsl:element>
      </xsl:template> 
      
      <xsl:template name="MSH.1">
         <xsl:element name="MSH.1.1">
            <xsl:value-of select="/HL7/MSH/MSH.1.1"/>
         </xsl:element>
      </xsl:template>
      
      <!-- Encoding Characters Test add lines of code-->
      <xsl:template name="MSH.2">
         <xsl:element name="MSH.2.1">
            <xsl:value-of select="/HL7/MSH/MSH.2.1"/>
         </xsl:element>
      </xsl:template>
      
      <!-- Sending Application-->
      <xsl:template name="MSH.3">
         <xsl:element name="MSH.3.1">
            <xsl:value-of select="/HL7/MSH/MSH.3.1"/>
         </xsl:element>
      </xsl:template>
      
      <xsl:template name="MSH.7">
         <xsl:element name="MSH.7.1">
            <xsl:value-of select="/HL7/MSH/MSH.7.1"/>
         </xsl:element>
      </xsl:template> 
      
      
      <xsl:variable name="messageType" select="/HL7/MSH/MSH.9.2" />
      <xsl:variable name="eventCode" select="/HL7/EVN/EVN.4.1" />
      
      <xsl:template name="MSH.9">
         
         <xsl:element name="MSH.9.1">
            <xsl:value-of select="/HL7/MSH/MSH.9.1"/>
         </xsl:element>
         
         <xsl:element name="MSH.9.2">  
            <xsl:choose>
                <xsl:when test="$messageType = 'A48' and $eventCode = '215'">  
                     <xsl:value-of select="'A28'"/>
                </xsl:when>   
       
               <xsl:when test="$messageType = 'A48' and $eventCode = '119'">  
                     <xsl:value-of select="'A46'"/>
               </xsl:when>   
               
               <xsl:when test="$messageType = 'A23'">  
                     <xsl:value-of select="'A11'"/>
               </xsl:when>   
               
                <xsl:otherwise>
                     <xsl:value-of select="$messageType"/>
                </xsl:otherwise>
            </xsl:choose>
         </xsl:element>
         
      </xsl:template>      
      
      <xsl:template name="MSH.10">
         <xsl:element name="MSH.10.1">
            <xsl:value-of select="/HL7/MSH/MSH.10.1"/>
         </xsl:element>
      </xsl:template>
      
      <xsl:template name="MSH.11">
         <xsl:element name="MSH.11.1">
            <xsl:value-of select="/HL7/MSH/MSH.11.1"/>
         </xsl:element>
      </xsl:template>      
      
      <xsl:template name="MSH.12">
         <xsl:element name="MSH.12.1">
            <xsl:value-of select="/HL7/MSH/MSH.12.1"/>
         </xsl:element>
      </xsl:template> 
      
      <xsl:template name="EVN">
      <xsl:element name="EVN">
      <xsl:element name="EVN.1.1">    
         
         <xsl:choose>
            <xsl:when test="$messageType = 'A48' and $eventCode = '215'">  
               <xsl:value-of select="'A28'"/>
            </xsl:when>   
            
            <xsl:when test="$messageType = 'A48' and $eventCode = '119'">  
               <xsl:value-of select="'A46'"/>
            </xsl:when>   
            
            <xsl:when test="$messageType = 'A23'">  
               <xsl:value-of select="'A11'"/>
            </xsl:when>   
            
            <xsl:otherwise>
               <xsl:value-of select="$messageType"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
         
         <xsl:element name="EVN.2.1"> 
            <xsl:value-of select="concat(format-number(/HL7/EVN/EVN.2.1,'000000000000'),'01')"/>  
         </xsl:element>
         
         <xsl:element name="EVN.6.1"> 
            <xsl:value-of select="concat(format-number(/HL7/EVN/EVN.6.1,'000000000000'),'01')"/>  
         </xsl:element>  
        </xsl:element>   
      </xsl:template>      
          
      <xsl:template name="PID">
         <xsl:element name="PID">
            
            <xsl:element name="PID.1.1">
               <xsl:value-of select="number(/HL7/PID/PID.1.1)"/>
            </xsl:element>
            
            <xsl:variable name="patientId" select="/HL7/ZI1/ZI1.2.1" />
            
            <xsl:element name="PID.2.1">
               <xsl:value-of select="$patientId"/>
            </xsl:element>     
            
            <xsl:if test="($patientId != '')"> 
            <xsl:element name="PID.2.5">
               <xsl:value-of select="'NAM'"/>
            </xsl:element>     
            
            <xsl:element name="PID.2.8">
               <xsl:value-of select="concat(/HL7/ZI1/ZI1.5.1,'28')"/>
            </xsl:element>  
            </xsl:if>  
            
            <xsl:element name="PID.3.1">
               <xsl:value-of select="/HL7/PID/PID.4.1[1]"/>
            </xsl:element>
            
            <xsl:element name="PID.3.3">
               <xsl:value-of select="'HMR'"/>
            </xsl:element>    
            
            <xsl:element name="PID.3.5">
               <xsl:value-of select="'MR'"/>
            </xsl:element> 
            
            <xsl:element name="PID.3.8">
               <xsl:value-of select="/HL7/ZI1/ZI1.21.1"/>
            </xsl:element> 
            
            <xsl:element name="PID.5.1">
               <xsl:value-of select="/HL7/PID/PID.5.1"/>
            </xsl:element> 
            
            <xsl:element name="PID.5.2">
               <xsl:value-of select="/HL7/PID/PID.5.2"/>
            </xsl:element> 
          
          
            <xsl:for-each select="/HL7/NK1">
            <xsl:choose>
                <xsl:when test="substring(./NK1.1.1,4,4) = '4'"> 
                   <xsl:element name="PID.6.1">
                      <xsl:value-of select="./NK1.2.1"/> 
                   </xsl:element>  
                   
                   <xsl:element name="PID.6.2">
                      <xsl:value-of select="./NK1.2.2"/> 
                   </xsl:element>   
                </xsl:when>
            </xsl:choose>
            </xsl:for-each>   
               
            <xsl:element name="PID.7.1">
               <xsl:value-of select="substring(/HL7/PID/PID.7.1,1,8)"/>
            </xsl:element> 
            
            <xsl:element name="PID.8.1">
               <xsl:value-of select="/HL7/PID/PID.8.1"/>
            </xsl:element> 
            
            <xsl:element name="PID.9.1">
               <xsl:value-of select="/HL7/PID/PID.9.1"/>
            </xsl:element> 
            
            <xsl:element name="PID.9.2">
               <xsl:value-of select="/HL7/PID/PID.9.2"/>
            </xsl:element> 
            
            <xsl:element name="PID.11.1">
               <xsl:value-of select="/HL7/PID/PID.11.1"/>
            </xsl:element> 
            
            <xsl:element name="PID.11.2">
               <xsl:value-of select="/HL7/PID/PID.11.2"/>
            </xsl:element> 
            
            <xsl:element name="PID.11.3">
               <xsl:value-of select="/HL7/PID/PID.11.3"/>
            </xsl:element> 
            
            <xsl:element name="PID.11.4">
               <xsl:value-of select="/HL7/PID/PID.11.4"/>
            </xsl:element> 
            
           <xsl:element name="PID.11.5">
               <xsl:value-of select="/HL7/PID/PID.11.5"/>
            </xsl:element> 
         
            <xsl:element name="PID.11.7">
               <xsl:value-of select="'H'"/>
            </xsl:element>
            
            <xsl:element name="PID.11.8">
               <xsl:value-of select="/HL7/PID/PID.11.8"/>
            </xsl:element> 
            
            <xsl:element name="PID.11.9">
               <xsl:value-of select="/HL7/PID/PID.11.9"/>
            </xsl:element> 
            
            <xsl:element name="PID.13.1">
               <xsl:value-of select="concat('(',/HL7/PID/PID.13.6,')','-',/HL7/PID/PID.13.7)"/>
            </xsl:element> 
            
            <xsl:element name="PID.13.2">
               <xsl:value-of select="/HL7/PID/PID.13.2"/>
            </xsl:element>
            
            <xsl:element name="PID.13.3">
               <xsl:value-of select="'PH'"/>
            </xsl:element>
            
            <xsl:variable name="areaCityCode" select="/HL7/PID/PID.14.6" />  
           <xsl:if test="($areaCityCode != '')"> 
              
                <xsl:element name="PID.14.1">
                   <xsl:value-of select="concat('(',$areaCityCode,')','-',/HL7/PID/PID.14.7)"/>
                </xsl:element> 
                
                <xsl:element name="PID.14.2">
                   <xsl:value-of select="/HL7/PID/PID.14.2"/>
                </xsl:element> 
        
                <xsl:element name="PID.14.3">
                    <xsl:value-of select="'PH'"/>
                </xsl:element>
           </xsl:if>  
            
            <xsl:element name="PID.15.1">
               <xsl:value-of select="/HL7/PID/PID.15.1"/>
            </xsl:element> 
            
            <xsl:element name="PID.15.2">
               <xsl:value-of select="/HL7/PID/PID.15.2"/>
            </xsl:element>          
            
            
             <xsl:choose>
                <xsl:when test="/HL7/PID/PID.16.1 = '1'">
                      <xsl:element name="PID.16.1">  
                      <xsl:value-of select="'ZN'"/>
                      </xsl:element> 
                   
                      <xsl:element name="PID.16.2">  
                      <xsl:value-of select="'Nouveau-ne'"/>
                      </xsl:element> 
                </xsl:when> 
                
                <xsl:when test="/HL7/PID/PID.16.1 = '3'">
                      <xsl:element name="PID.16.1">  
                      <xsl:value-of select="'M'"/>
                      </xsl:element>          
                   
                      <xsl:element name="PID.16.2">  
                      <xsl:value-of select="'Marie'"/>
                      </xsl:element>                    
                </xsl:when> 
                
                <xsl:when test="/HL7/PID/PID.16.1 = '4'">
                      <xsl:element name="PID.16.1">  
                      <xsl:value-of select="'W'"/>
                      </xsl:element>                      
                   
                      <xsl:element name="PID.16.2">  
                      <xsl:value-of select="'Divorce'"/>
                      </xsl:element>                                       
                </xsl:when>
                
                <xsl:otherwise> 
                      <xsl:element name="PID.16.1">  
                      <xsl:value-of select="'S'"/>
                      </xsl:element>
                   
                      <xsl:element name="PID.16.2">  
                      <xsl:value-of select="'Celibataire'"/>
                      </xsl:element>                          
                </xsl:otherwise>
             </xsl:choose>
            
             <xsl:element name="PID.30.1">
               <xsl:value-of select="/HL7/PID/PID.30.1"/>
             </xsl:element> 
   
            </xsl:element>    
      </xsl:template>    
        
      <xsl:template name="NK1">    
         <xsl:for-each select="/HL7/NK1[./NK1.2.1!='']">
            
               <xsl:element name="NK1">
                  
                  <xsl:element name="NK1.1.1">
                     <xsl:value-of select="position()"/> 
                  </xsl:element>
                                    
                  <xsl:element name="NK1.2.1">
                     <xsl:value-of select="./NK1.2.1"/>
                  </xsl:element>  
                  
                  <xsl:element name="NK1.2.2">
                     <xsl:value-of select="./NK1.2.2"/>
                  </xsl:element> 
                  
                  <xsl:variable name="setID" select="./NK1.1.1" /> 
                  
                     <xsl:choose>        
                        <xsl:when test="substring(./$setID,4,4) = '1'">
                           <xsl:element name="NK1.3.1">
                              <xsl:value-of select="'FTH'"/> 
                           </xsl:element>   
                        </xsl:when>
                        
                        <xsl:when test="substring(./$setID,4,4) = '2'">
                           <xsl:element name="NK1.3.1">
                              <xsl:value-of select="'SPO'"/> 
                           </xsl:element>     
                        </xsl:when>
                        
                        <xsl:when test="substring(./$setID,4,4) = '3'">
                           <xsl:element name="NK1.3.1">
                              <xsl:value-of select="'EMC'"/> 
                           </xsl:element>     
                        </xsl:when>
                        
                        <xsl:when test="substring(./$setID,4,4) = '4'"> 
                           <xsl:element name="NK1.3.1">
                              <xsl:value-of select="'MTH'"/> 
                           </xsl:element>  
                        </xsl:when>
                        
                        <xsl:when test="substring(./$setID,4,4) = '5'">
                           <xsl:element name="NK1.3.1">
                              <xsl:value-of select="'EMR'"/> 
                           </xsl:element>   
                        </xsl:when>    
                     </xsl:choose>     
                  </xsl:element> 
             
          </xsl:for-each>      
      </xsl:template>
         
      <xsl:template match="@* | node()">
         <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
         </xsl:copy>
      </xsl:template>
   </xsl:stylesheet>

