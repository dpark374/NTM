<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	exclude-result-prefixes="msxsl">
<!-- changes made on 22TH Jun 2020 PDMD6977	-->
<!--	xmlns:msxsl="http://exslt.org/common" -->
	
	<!--================================================================================== -->
	<!--                      HTML OUTPUT FOR RENDITION                                    -->
	<!--================================================================================== -->
	<xsl:output method="html" encoding="UTF-8" indent="yes"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
        <xsl:decimal-format name="scale" decimal-separator="." grouping-separator=" "/>

	<!--================================================================================== -->
	<!--                             GLOBAL VARIABLES                                      -->
	<!--================================================================================== -->
	<xsl:variable name="small-case" select="abcdefghijklmnopqrstuvwxyz"/>
	<xsl:variable name="upper-case" select="ABCDEFGHIJKLMNOPQRSTUVWXYZ"/>
	<xsl:key name="item" match="item" use="@chart"/>
	<xsl:key name="charts_id" match="NM_MISC_INSTRUCT_PNCNCP" use="INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id"/>
	<xsl:key name="editions_id" match="NM_MISC_INSTRUCT_PNCNEP" use="INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id"/>
	<xsl:key name="withdrawn_id" match="NM_MISC_INSTRUCT_PNCNPW" use="INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id"/>
	<xsl:variable name="lower-alpha">
		<list-values>
		<item num="1">a</item>
		<item num="2">b</item>
		<item num="3">c</item>
		<item num="4">d</item>
		<item num="5">e</item>
		<item num="6">f</item>
		<item num="7">g</item>
		<item num="8">h</item>
		<item num="9">i</item>
		<item num="10">j</item>
		<item num="11">k</item>
		<item num="12">l</item>
		<item num="13">m</item>
		<item num="14">n</item>
		<item num="15">o</item>
		<item num="16">p</item>
		<item num="17">q</item>
		<item num="18">r</item>
		<item num="19">s</item>
		<item num="20">t</item>
		<item num="21">u</item>
		<item num="22">v</item>
		<item num="23">w</item>
		<item num="24">x</item>
		<item num="25">y</item>
		<item num="26">z</item>
		<item num="27">aa</item>
		<item num="28">ab</item>
		<item num="29">ac</item>
		<item num="30">ad</item>
		<item num="31">ae</item>
		<item num="32">af</item>
		<item num="33">ag</item>
		<item num="34">ah</item>
		<item num="35">ai</item>
		<item num="36">aj</item>
		<item num="37">ak</item>
		<item num="38">al</item>
		<item num="39">am</item>
		<item num="40">an</item>
		<item num="41">ao</item>
		<item num="42">ap</item>
		<item num="43">aq</item>
		<item num="44">ar</item>
		<item num="45">as</item>
		<item num="46">at</item>
		<item num="47">au</item>
		<item num="48">av</item>
		<item num="49">aw</item>
		<item num="50">ax</item>
		</list-values>
	</xsl:variable>
	<!--<xsl:template match="@*|node()">
		<xsl:if test=". != '' or ./@* != ''">
			<xsl:copy>
				<!-\-<xsl:copy-of select = "@*"/>-\->
				<xsl:apply-templates />
			</xsl:copy>
		</xsl:if>
	</xsl:template>-->
	<!--================================================================================== -->
	<!--XSLT to transform sample XML from HPD DB export into a display format. 
		Last updated: June 30, 2017                                                        -->
	<!--================================================================================== -->
	<xsl:template match="/">
		<html>
			<head>
			<meta http-equiv="X-UA-Compatible" content="IE=edge" />	
				
				<!-- If using attached images etc in MS Word uncomment then you may have to edit the base path to point to 
					 the folder where the document was exported for word to locate the files -->
				<xsl:if test="normalize-space(NTC_PUBLICATION/PUBLISHED_FILENAME)">
					<base>
						<xsl:variable name="last-hyphen" >
							<xsl:call-template name="last-index-of">
								<xsl:with-param name="txt" select="NTC_PUBLICATION/PUBLISHED_FILENAME"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute>
						<xsl:attribute name="href">
							<xsl:if test="//SECTION_NUMBER = 'I'" >
								<xsl:call-template name="EXPLANATORY_NOTES"></xsl:call-template>
							</xsl:if>
							<xsl:if test="//SECTION_NUMBER = 'II'" >
								<xsl:call-template name="miscellneous-section"></xsl:call-template>
							</xsl:if>
							<xsl:if test="//SECTION_NUMBER = 'III'" >
								<xsl:call-template name="nm_gen_seciii"></xsl:call-template>
							</xsl:if>
							<xsl:if test="//SECTION_NUMBER = 'IV'" >
								<xsl:call-template name="nm_chart_section"></xsl:call-template>
							</xsl:if>
							<xsl:if test="//SECTION_NUMBER = 'V'" >
								<xsl:call-template name="nm_content_comp"></xsl:call-template>
							</xsl:if>
							<xsl:if test="//SECTION_NUMBER = 'VI'" >
								<xsl:call-template name="nm_gen_secvi"></xsl:call-template>
							</xsl:if>
							<xsl:if test="//SECTION_NUMBER = 'VII'" >
								<xsl:call-template name="nm_gen_secvi"></xsl:call-template>
							</xsl:if>
						
							<!--<xsl:value-of select="substring(NTC_PUBLICATION/PUBLISHED_FILENAME,1,$last-hyphen)"/>-->
						</xsl:attribute>
					</base>
				</xsl:if>
				<!--<base href="N:\HPD\shared\HPD310\PM_LINZConfiguration\R5\Instructions_Stylesheets\" target="_blank" />-->
				<style type="text/css">				
					body{
					    <!-- width: 690px; -->
					    <!-- width:100%; -->
					    width:8.5in;
					    font-size: 9pt;
					    font-family: arial;
					}
					h1{
					    font-size: 22pt;
					    font-family: arial;
					    text-transform: uppercase;
					    max-width: 100px;
					    margin: 0 auto;
					}
					
					h2{
					    font-size: 15pt;
					    font-family: arial;
					    text-transform: uppercase;
					    margin: 0 auto;
					}
					
					h3{
					    font-size: 15pt;
					    font-family: arial;
					    font-weight: normal;
					    margin: 0 auto;
					}
					
					h4{
					    font-size: 13pt;
					    font-family: arial;
					    font-weight: normal;
					    margin: 0 auto;
					}
					
					h5{
					    font-size: 11pt;
					    font-family: arial;
					    text-transform: uppercase;
					    margin: 0 auto;
					}
					
					h6{
					    font-size: 11pt;
					    font-family: arial;
					    font-weight: normal;
					    margin: 0 auto;
					}</style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="date">
		<xsl:param name="yyyy-mm-dd"/>
		<xsl:variable name="yyyy" select="substring-before($yyyy-mm-dd, '-')"/>
		<xsl:variable name="mm-dd" select="substring-after($yyyy-mm-dd, '-')"/>
		<xsl:variable name="mm" select="substring-before($mm-dd, '-')"/>
		<xsl:variable name="dd" select="substring-after($mm-dd, '-')"/>
		<xsl:variable name="d" select="substring($dd, 2, 1)"/>

		<xsl:choose>
			<xsl:when test="not($dd &gt; '9')">
				<xsl:value-of select="$d"/>
			</xsl:when>
			<xsl:when test="($dd &gt; '9')">
				<xsl:value-of select="$dd"/>
			</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="$mm = '01'"> January </xsl:when>
			<xsl:when test="$mm = '02'"> February </xsl:when>
			<xsl:when test="$mm = '03'"> March </xsl:when>
			<xsl:when test="$mm = '04'"> April </xsl:when>
			<xsl:when test="$mm = '05'"> May </xsl:when>
			<xsl:when test="$mm = '06'"> June </xsl:when>
			<xsl:when test="$mm = '07'"> July </xsl:when>
			<xsl:when test="$mm = '08'"> August </xsl:when>
			<xsl:when test="$mm = '09'"> September </xsl:when>
			<xsl:when test="$mm = '10'"> October </xsl:when>
			<xsl:when test="$mm = '11'"> November </xsl:when>
			<xsl:when test="$mm = '12'"> December </xsl:when>
		</xsl:choose>

		<xsl:value-of select="$yyyy"/>

	</xsl:template>

	<!--================================================================================== -->
	<!-- A named template for section heading                                              -->
	<!--================================================================================== -->
	<xsl:template name="section-header">
		<xsl:param name="section-number"/>
		<span><br style="mso-special-character:line-break; page-break-before:always"/></span>
		
		<br/>
		<div style="width:100%;">
			<table style="width:100%;">
				<tr>
					<td width="51%"><p style="text-align:right;font-size:10pt;font:arial"><b><xsl:value-of select="$section-number"/></b></p></td>
					<td width="49%">
						<p style="text-align:right; font-size:10pt; padding-bottom:0px; font-family:'Arial';">
							<xsl:text>NZ NOTICES TO MARINERS</xsl:text>
							<br/>
							<b>
							<xsl:text>EDITION </xsl:text>
								<xsl:value-of select="/NTC_PUBLICATION/EDITION"/></b>
							<br/>
							<i>
								<xsl:call-template name="date">
									<xsl:with-param name="yyyy-mm-dd" select="/NTC_PUBLICATION/PUBLISH_DATE"/>
								</xsl:call-template>
							</i>
						</p>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>

	<!--================================================================================== -->
	<!-- A template for root element                                                       -->
	<!--================================================================================== -->
	<xsl:template match="NTC_PUBLICATION">
		<!-- This is the top most division in the document for NZ logo and section-head -->
		<div style="width:100%;">
			<table style="width:100%;">
				<tr>
				<td style="width:100px;">
					<img width="250" height="60">
						<xsl:attribute name="src">
							<xsl:value-of select="'N:\HPD\shared\HPD310\PM_LINZConfiguration\R5\Instructions_Stylesheets\LINZ-logo.jpg'"/>
						</xsl:attribute>
					</img>
				</td>
				<td>
					<p style="text-align:right; font-size:10pt; padding-bottom:10px; font:'Arial'"><b>
						<xsl:text>EDITION </xsl:text>
						<xsl:value-of select="EDITION"/></b>
					</p>
					<p style="text-align:right; font-size:10pt; font:arial">
						<i>
							<xsl:call-template name="date">
								<xsl:with-param name="yyyy-mm-dd" select="PUBLISH_DATE"/>
							</xsl:call-template>
						</i>
					</p>
				</td>
				</tr>
			</table>
		</div>
		<!-- Main title -->
		<div align="center">
			<p><br/><br/></p>
			<p style="font:arial;font-size:22pt;font-weight:bold;margin-bottom:0px;">NEW ZEALAND<br/>NOTICES TO MARINERS</p>

			<!-- This variable is to extract minimum and maximum notice numbers affected
			     from all the Temporary, Preliminary and Permanent notices -->
			<xsl:variable name="min-max-range">
				<xsl:for-each select="//NM_TORP_NTC[not(ancestor::CANCELLED_NOTICE_LIST)]/PUBLISH_NUMBER | //NM_CHART_NTC[not(ancestor::CANCELLED_NOTICE_LIST)]/PUBLISH_NUMBER">
					
					<xsl:sort select="substring-before(.,'/')" data-type="number" order="ascending"/>
					<!--<xsl:if test="number(position()) = 1">-->
					<xsl:if test="position()= '1'">
						<xsl:variable name="min-value" select="substring-before(.,'/')"/>
						
						<xsl:value-of select="$min-value"/>
						<xsl:text> - </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="//NM_TORP_NTC[not(ancestor::CANCELLED_NOTICE_LIST)]/PUBLISH_NUMBER | //NM_CHART_NTC[not(ancestor::CANCELLED_NOTICE_LIST)]/PUBLISH_NUMBER">
					
					<xsl:sort select="substring-before(.,'/')" data-type="number" order="ascending" />
					<xsl:if test="position()= last()">
						<xsl:variable name="min-value" select="substring-before(.,'/')"/>
						<xsl:value-of select="$min-value"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<!-- Subtitle info with min-and-max notice numbers affected information -->
			<xsl:if test="normalize-space($min-max-range)">
			<p style="text-align:center; font:Arial; font-size:14pt; margin-top:6px; margin-bottom:0px;"><b>Notices NZ <xsl:value-of
				select="$min-max-range"/></b></p>
			</xsl:if>
			<!-- Static publishing information -->
			<p style="text-align:center; font:Arial; font-size:10pt;margin-top:10px;margin-bottom:0px;">
				<b>Published fortnightly by the New Zealand Hydrographic Authority</b></p>
				
			<p style="text-align:center; font:Arial; font-size:10pt;margin-top:8px;margin-bottom:8px;">
					<!-- Copyright year information is dynamic; grabbed from published year -->
				<i>© Crown Copyright <xsl:value-of select="substring(PUBLISH_DATE,1,4)"/>. All rights reserved. Permission is not required to make
					analogue copies of these Notices but such copies are not to be sold.</i>
			</p>
		</div>

		<!-- Table of Contents -->
		<hr style="height:1px;border:none;color:#000;background-color:#000;"/>
		<br/>
		<p style="text-align:center; padding-top: 10px; padding-bottom: 10px;font-size:10pt;margin-bottom:.0001pt">
			<b>CONTENTS</b></p>

		<table class="contents" style="width:100%;font:arial;font-size:11pt;">
			<tr>
				<td style="width:5%;"><a href='#section-one'>I</a></td>
				<td style="width:92%;"><a href='#section-one'>Explanatory Notes.</a></td>
			</tr>
			<tr>
				<td><a href="#section-two">II</a></td>
				<td><a href="#section-two">Miscellaneous Notices.</a></td>
			</tr>
			
			<tr>
				<td><a href="#section-three">III</a></td>
				<td><a href="#section-three">General Notices. </a>
				</td>
			</tr>
		
			<tr>
				<td><a href="#section-four">IV</a></td>
				<td><a href="#section-four">Notices to Mariners.</a></td>
			</tr>
			<tr>
				<td><a href="#section-five">V</a></td>
				<td><a href="#section-five">Corrections to New Zealand Publications.</a></td>
			</tr>
			<tr>
				<td><a href="#section-six">VI</a></td>
				<td><a href="#section-six">Corrections to Admiralty Publications.</a></td>
			</tr>
			<tr>
				<td><a href="#section-seven">VII</a></td>
				<td><a href="#section-seven">Navigational Warnings.</a></td>
			</tr>
		</table>

		<br/><br/><br/>
		<hr style="height:2px;border:none;color:#000;background-color:#000;"/>
		<br/>
		<!--================================================================================== -->
		<!-- A division for front-page information                                             -->
		<!--================================================================================== -->
		<div>
			<p style="text-align:justify;">New Zealand Notices to Mariners are the authority for correcting New Zealand nautical
				publications and those charts within New Zealand’s area of charting responsibility
				as shown in <a href="https://www.linz.govt.nz/sea/maritime-safety/notices-mariners/nz-annual-notices-mariners">Annual Notice No. 1.</a></p>
				<p style="text-align:justify;">
				<B>Mariners are requested to immediately inform the New Zealand Hydrographic Authority,
					Land Information New Zealand, 155 The Terrace, PO Box 5501, Wellington 6145, New Zealand,
					Phone: 0800 665 463 or +64 (0)4 460 0110, Fax: +64 (0)4 460 0161, email: </B>
				<a href="mailto:ntm@linz.govt.nz">ntm@linz.govt.nz</a>
				<B>, of the discovery of new or suspected dangers to navigation, or shortcomings in charts
					and publications. A copy of a Hydrographic Note, a convenient form on which to send
					such information, is included at the end of Section VII of the Fortnightly Notices
					to Mariners.</B>
				</p>
			<p style="text-align:justify;">
				<B>Changes or defects in aids to navigation should be reported to the Rescue Coordination
					Centre New Zealand (RCCNZ) via the nearest New Zealand Coastal Maritime Radio Station
					Phone: +64 (0)4 577 8030, Fax: +64 (0)4 577 8038 or +64 (0)4 577 8041, email: </B>
				<a href="mailto:rccnz@maritimenz.govt.nz">rccnz@maritimenz.govt.nz</a>.
			</p>
			<p style="text-align:justify;">Copies of these Notices can be obtained from Land Information New Zealand, Maritime
				New Zealand, Principal Chart Agents at the major ports of New Zealand and the internet:
				<a href="https://www.linz.govt.nz/">www.linz.govt.nz</a>.
			</p>
		</div>
		<br/><br/><br/><br/><br/><br/>
		<!--================================================================================== -->
		<!-- A division for front page information                                      -->
		<!--================================================================================== -->
		<xsl:if test="//NM_FP_PARA[ancestor::NM_FRONT_PAGE]/P !=''">
		<div>
			<xsl:for-each select="//NM_FP_PARA[ancestor::NM_FRONT_PAGE]/P">
				<p style="text-align:justify;">
					<xsl:apply-templates/>
				</p>
			</xsl:for-each>
		</div>
		<br/><br/><br/><br/><br/><br/>
		</xsl:if>
		<!-- Footer logos -->
		<div style="width:100%;">
			<table style="width:100%;">
				<td width="350px"><b style="font:arial;font-size:9pt;">New Zealand Hydrographic Authority</b>
					</td>
				<td width="200px" style="align:right;">
					<img width="120" height="12" align="right">
						<xsl:attribute name="src">
							<xsl:value-of select="'N:\HPD\shared\HPD310\PM_LINZConfiguration\R5\Instructions_Stylesheets\Footer_Right.jpg'"/>
						</xsl:attribute>
					</img></td>
			</table>
		</div>
        
		<!--================================================================================== -->
		<!-- A division for explanatory notes information                                      -->
		<!--================================================================================== -->
		<xsl:call-template name="EXPLANATORY_NOTES"/>
		
		<!--================================================================================== -->
		<!-- A division for miscellaneous section information                                  -->
		<!--================================================================================== -->
		<xsl:call-template name="miscellneous-section"/>

		<!--================================================================================== -->
		<!-- A division for general section information                                        -->
		<!--================================================================================== -->
		<xsl:call-template name="nm_gen_seciii"/>

		<!--================================================================================== -->
		<!-- A division for chart notices information                                          -->
		<!--================================================================================== -->
		<xsl:apply-templates select="//NM_CHART_SECTION"/>
		
		<!--================================================================================== -->
		<!-- A division for corrections information                                             -->
		<!--================================================================================== -->
		<xsl:apply-templates select="//NM_CAT_SECTION"/>
		<!--================================================================================== -->
		<!-- A division for annual notices to mariners information                             -->
		<!--================================================================================== -->
		<xsl:apply-templates select="//NM_CAT_ANTOM"/>
		<!--================================================================================== -->
		<!-- A division for light-list corrections                                             -->
		<!--================================================================================== -->
		<xsl:apply-templates select="//NM_SECTION_LIGHTLIST_PRODUCT"/>
		<br/><br/><hr/>
		<xsl:value-of select="//HITS_NUMBER[parent::NM_CAT_SECTION]"/>
		<!--================================================================================== -->
		<!-- A division for corrections to admiralty                                           -->
		<!--================================================================================== -->
		<xsl:call-template name="nm_gen_secvi"/>

		<!--================================================================================== -->
		<!-- A division for navigational warnings                                              -->
		<!--================================================================================== -->
		<xsl:call-template name="nm_gen_secvii"/>

		<!--================================================================================== -->
		<!-- A division for static hydrograhpic note information                               -->
		<!--================================================================================== -->
		<xsl:call-template name="generate-hydrographic-note"/>

		<br style="page-break-before:always"/>
		<!--================================================================================== -->
		<!-- A division for attachments at the end of the document                             -->
		<!--================================================================================== -->
		<xsl:apply-templates select="//ATTACHMENT_LIST[not(parent::NM_CAT_ANTOM) and not(parent::NM_GEN_SECIII)]"/>
	</xsl:template>

	<!-- A template for generic sections node -->
	<xsl:template name="EXPLANATORY_NOTES">
		<!-- section header -->
	
		<xsl:call-template name="section-header">
			<xsl:with-param name="section-number">
			
				<xsl:value-of select="'I'"/>
			</xsl:with-param>
		</xsl:call-template>
		<div >
			<br/>
			<!-- section title -->
			<h5 style="text-align:center; font:arial;font-size:9pt;">
				<a name ='section-one'><xsl:value-of select="'EXPLANATORY NOTES'"/></a>
			</h5><br/><br/>
			
			<!-- explanatory static paragraphs -->
			<div style="text-align: justify" ><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:5px;">This edition of
				Notices to Mariners includes all significant information affecting New Zealand nautical
				charts and publications which the New Zealand Hydrographic Authority (NZHA) has become aware
				of since the last edition. All reasonable efforts have been made to ensure the accuracy and
				completeness of the information, including third party information, on which these updates
				are based. The NZHA regards third parties from which it receives information as reliable,
				however the NZHA cannot verify all such information and errors may therefore exist. The NZHA
				does not accept liability for errors in third party information.</span></div><br/>
			<div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:5px;margin-top:12px;"><b>Correction of
				Charts and Publications by the User.</b> New Zealand Notices to Mariners contain
				important information and should be used to keep the specified charts and publications up to
				date.</span></div><br/>
			<div style="text-align: justify;margin-bottom:6pt;"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:4px;margin-top:12px;"><b>Charts.</b> The
				notices in Section IV give instructions for the correction of charts.</span></div>
			<div style="text-align: justify;margin-bottom:6pt;"><span style="text-align:justify;font:arial:font-size:9pt;margin-top:1px;margin-bottom:4px;">Geographical positions refer to the largest scale chart unless otherwise stated. They are
				normally given in degrees, minutes and decimals of a minute, but may occasionally quote
				seconds for convenience when plotting from the graduation of some older-style charts.</span></div>
			<div style="text-align: justify;margin-bottom:6pt;"><span style="text-align:justify;font:arial:font-size:9pt;margin-top:1px;margin-bottom:4px;">Bearings are true, reckoned clockwise from 000° to 359°; those relating to lights are given
							as seen by an observer from seaward.</span></div>
			<div style="text-align: justify;margin-bottom:6pt;"><span style="text-align:justify;font:arial:font-size:9pt;margin-top:1px;margin-bottom:4px;">
				Alterations to depth contours, deletion of depths to make way for new detail, etc. are not
				mentioned unless they have some navigational significance.</span></div>
			<div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-top:1px;margin-bottom:7px;">
				Blocks, notes or tracings accompanying notices in Section IV are placed at the end of this
				publication.</span></div><br/>
			<div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:4px;margin-top:12px;"><b>Permanent Notices.</b> A <a href="https://www.linz.govt.nz/sites/default/files/media/ntm/files/cumulist.pdf?download=1">Cumulative List</a> of permanent corrections affecting charts is published on the LINZ website.</span></div><br/>
			<div style="text-align: justify;margin-bottom:6pt;"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:4px;margin-top:12px;"><b>Temporary and
				Preliminary Notices.</b> These are indicated by (T) or (P) respectively after the notice
				number. Charts are not corrected for them before issue; they should be corrected in pencil 
				on receipt.</span></div>
			<div style="text-align: justify;margin-bottom:6pt;"><span style="text-align:justify;font:arial:font-size:9pt;margin-top:1px;margin-bottom:4px;">An 
												asterisk (*) in a re-issued notice indicates a new or revised entry.</span></div>
			<div style="text-align: justify;"><span style="text-align:justify;font:arial:font-size:9pt;margin-top:1px;margin-bottom:7px;">A list
				of <a href="https://www.linz.govt.nz/sites/default/files/media/ntm/files/temp-perm.pdf">(T) and (P) Notices in force</a> is published on the LINZ website.</span></div><br/>
			<div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:7px;margin-top:12px;"><b>New Zealand
														Publications.</b> Corrections to New Zealand Publications are given in Section V. </span></div><br/>
			<div style="text-align: justify;margin-bottom:6pt;"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:4px;margin-top:12px;"><b>Light Lists.</b> 
				The detailed correction to the Light List is given in Section V and may not be published 
				in the same edition as the chart correcting notice. The entire entry for each light is printed, 
				and an asterisk (*) is shown under the column which contains an amendment. In the case of a new
				light, an asterisk (*) appears under all the columns. New and extensively altered entries are intended
				to be pasted in. It is recommended that a manuscript entry be made for all shorter
				corrections.</span></div>
	        <div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-top:1px;margin-bottom:7px;">It is
				emphasised that the <a href="https://www.linz.govt.nz/sea/nautical-information/list-lights">List of Lights</a> is the authority for lights and that many alterations,
				especially those of a temporary but operational nature, may be promulgated only as corrections to 
				the List of Lights.</span></div><br/>
			<br/>
		</div>
		
		<!--Section I, double explanatory note title. This is exported from PM and thus does not need to be duplicated in Style sheet.-->
		<!--<xsl:if test="//NM_GEN_SECI/NAME !=''">
			<div>
				<br/>
				<!-\- section title -\->
				<h5 style="text-align:center; font:arial;font-size:9pt;">
					<xsl:value-of select="//NM_GEN_SECI/NAME"/>
				</h5><br/>
				
				<!-\- explanatory static paragraphs -\->
				<xsl:for-each select="//PARA_COMPLEX[ancestor::NM_EXPLANATORY_NOTE]">
					<xsl:call-template name="print-para"/>
				</xsl:for-each>
				
			</div>
		</xsl:if>-->
		<div><br/>
			<!-- sub-title information -->
			<h5 style="text-align:center;font-size:9pt;"><b>
				<xsl:value-of select="'THE USE OF CHARTS AND ASSOCIATED PUBLICATIONS'"/></b>
			</h5><br/><br/>

			<!-- sub-section paragraphs -->
			<div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:7px;"><b>Reliance on Charts
				and Associated Publications.</b> While every effort is made to ensure the accuracy of
				the information on New Zealand charts and other publications, it should be appreciated that
				it may not always be complete and up to date. The mariner must be the final judge of the
				reliance to be placed on the information given, bearing in mind their particular
				circumstances, local pilotage guidance and the judicious use of available navigational aids.</span></div><br/>
				<div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:7px;margin-top:12px;"><b>Charts.</b> Charts
				should be used with prudence: there are areas where the source data are old, incomplete or
				of poor quality. The mariner should use the largest scale appropriate for his particular
				purpose; apart from being the most detailed, the larger scales are usually corrected first.
				When extensive new information (such as a new hydrographic survey) is received, some months
				may elapse before it can be fully incorporated in published charts. On small scale charts of
				ocean areas where hydrographic information is, in many cases, still sparse, charted shoals
				may be in error as regards position, least depth and extent. Undiscovered dangers may exist,
				particularly away from well-established routes.</span></div><br/>
					<div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:7px;margin-top:12px;"><b>Symbols.</b>
				Details on symbols and abbreviations used on charts are those shown in publication NP5011
				(INT 1) Symbols and Abbreviations Used on ADMIRALTY Paper Charts, published by the United
				Kingdom Hydrographic Office.</span></div><br/>
						<div style="text-align: justify"><span style="text-align:justify;font:arial:font-size:9pt;margin-bottom:7px;margin-top:12px;"><b>Further
				guidance.</b> The Mariner’s Handbook (NP100) gives a fuller explanation of the
				limitations of charts. All users should study it in their own interest.</span></div>
		</div>
		<xsl:if test="//NM_GEN_SECI/NAME !=''">
			<div>
				
				<br/><br/>
				
				<!-- sub-title information -->
				<p style="text-align:center;font-size:9pt;"><b>
					<xsl:value-of select="//NM_USEOFCHART_NOTE/NAME"/></b>
				</p>
				
				<!-- sub-section paragraphs -->
				<xsl:for-each select="//PARA_COMPLEX[ancestor::NM_USEOFCHART_NOTE]">
					<xsl:call-template name="print-para"/>
				</xsl:for-each>
				<br/>
			</div>
		</xsl:if>
		
	</xsl:template>

	<xsl:template name="miscellneous-section">
		<!-- Section II - Product Announcements - section header -->
		
		<xsl:call-template name="section-header">
			<xsl:with-param name="section-number">
			
				<xsl:value-of select="'II'"/>
			</xsl:with-param>
		</xsl:call-template>
		
		<div id="section-two">
			<br/><br/>
			<h5 style="text-align:center;font-size:10pt;">
				<a name = 'section-two'></a>
				<xsl:value-of select="'MISCELLANEOUS NOTICES'"/>
				
			</h5>
			<br/><br/>
			<h6 style="text-align:center;font-size:10pt;"><b>
				<xsl:value-of select="'Index of Product Announcements'"/></b>
			</h6>
			<br/><br/>
			<hr style="height:2px;border:none;color:#000;background-color:#000; width:150px;margin-bottom:12px;"/>

			<!-- ================================================= -->
			<!-- Chart Table                                       -->
			<!-- ================================================= -->
			<p style="text-align:center;font-size:9pt;font:arial;margin-top:0px;margin-bottom:0px;">
				<xsl:value-of select="'Chart No.'"/>
			</p>
			<hr style="height:1px;border:none;color:#000;background-color:#000; width:150px;"/>

			<!-- Chart table for list of charts affected -->
			<div style="align:center;width:100%;text-align:left;margin-left:70pt;">
				<table style="margin-left:220pt;">
					<tbody>						
                        
                        <xsl:variable name="misc_section" select="//NM_MISC_SECTION"/>

                        <!-- iterate over all the affected charts which are linked to instructions in the misc notices section -->
                        <xsl:for-each select="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = $misc_section//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]">
                        	<!--<xsl:sort select="CHTNUM"  order="ascending" data-type="text"/>-->
                        	<xsl:sort select="substring(normalize-space(CHTNUM),1,2)" order="ascending" data-type="text"/>
                        	<xsl:sort select="normalize-space(translate(CHTNUM,'NZ',''))"  order="ascending" data-type="number"/>
                        	<!--<xsl:sort select="normalize-space(translate(.,'NZ',''))" order="ascending" data-type="number"/>-->
                            <xsl:variable name="chart" select="."/>
                        	<!--<xsl:text> CHART_NUM </xsl:text>
                        	<xsl:value-of select="normalize-space(translate(CHTNUM,'NZ',''))"/>
                        	<xsl:text> %%%%% </xsl:text>
                        	<xsl:value-of select="CHTNUM"/>
                        	<xsl:text> @@@@ </xsl:text>-->
                        	<!--<tr style="margin-left:25pt;">-->
                        	<tr>
                        		<td style="text-align: center;">
                        			<xsl:value-of select="concat(substring(CHTNUM,1,2),' ',substring(CHTNUM,3,15))"/>
                                    <!--<xsl:value-of select="CHTNUM"/>-->
                                    <xsl:if test="INTNUM and normalize-space(INTNUM ) != '' ">
                                        <xsl:text> (</xsl:text>										
                                        <xsl:value-of select="normalize-space(INTNUM)"/>
                                        <xsl:text>)</xsl:text>
                                    </xsl:if>
                                </td>
                            <!--</tr>-->
                        		</tr>
                        </xsl:for-each>
                        
                        <!-- Add to the List affected ENC charts if not already listed in the paper chart list -->
						<xsl:for-each select="//ENC_NAME[ancestor::NM_MISC_INSTRUCT_ENC or ancestor::NM_MISC_INSTRUCT_ENC_TBPUB or ancestor::NM_ENCPW]">
							<!--<xsl:sort select="normalize-space(translate(.,'NZ',''))" order="ascending" data-type="number"/>-->
							<xsl:sort select="." order="ascending" data-type="text"/>
                            <xsl:variable name="enc" select="."/>
                            <xsl:if test="not(//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = $misc_section//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]/CHTNUM = .)">
                            	<tr>
                            		<td style="text-align: center;" >
                                        <xsl:value-of select="."/>
                                    	<!--<xsl:value-of select="concat(substring(.,1,2),' ',substring(.,3,15))"/>-->
                                    </td>
                                </tr>
                            </xsl:if>
						</xsl:for-each>
						
					</tbody>
				</table>
			</div>
		</div>
		
		<div>
			<hr
				style="height:2px;border:none;color:#000;background-color:#000; width:130px;margin-bottom:12px;"/>
			<p style="text-align:center;font:arial;font-size:9pt;margin-top:0px;margin-bottom:0px;">
				<xsl:value-of select="'Publication'"/>
			</p>
			<hr
				style="height:1px;border:none;color:#000;background-color:#000; width:130px;margin-top:12px;"/><br/>
			<p style="text-align:center;font:arial;font-size:9pt;margin-top:0px;margin-bottom:0px;">
				<xsl:for-each select="//NM_PUB_NAME[ancestor::NM_MISC_SECTION]">
					<xsl:choose>
						<xsl:when test=". != ''">
							<xsl:apply-templates select="."/><br/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>nil</xsl:text><br/>
						</xsl:otherwise>
					</xsl:choose>
					<!--<xsl:apply-templates select="."/><br/>-->
				</xsl:for-each>
			</p>
		</div>

		<xsl:if test="(//NM_MISC_INSTRUCT_PNCNCP[ancestor::NM_PNC_NECPUB] or //NM_MISC_INSTRUCT_PNCNEP[ancestor::NM_PNC_NEPUB]) or //NM_MISC_INSTRUCT_PNCPW">
		<!-- ================================================= -->
		<!-- Charts Published Section                          -->
		<!-- ================================================= -->
			<br/><br/><br/><br/><br/>
			<p style="text-align:left;font-size:9pt;margin-bottom:0px;margin-top:0px">
			<b><xsl:value-of select="'NEW ZEALAND CHARTS. New Chart(s), New Edition(s), Withdrawn Chart(s)'"/></b>
		</p><br/>
			
			<xsl:choose>
				<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNCP[ancestor::NM_PNC_NECPUB])">
					
				</xsl:when>
				<xsl:otherwise>
			<!--<p style="text-align:left;margin-bottom:0px;margin-top:0px ">
			<b><xsl:value-of select="'New Chart(s) Published'"/></b>
		</p><br/>-->
				<xsl:variable name="number_of_new_charts_published">
					<xsl:if test ="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNCP//PPRPAN/@id]">
						<xsl:value-of select="count(//NM_MISC_INSTRUCT_PNCNCP)"/>
					</xsl:if>	
				</xsl:variable>
					<xsl:choose>
						<xsl:when test="$number_of_new_charts_published = 1">
							<p style="text-align:left;margin-bottom:0px;margin-top:0px ">
								<b><xsl:value-of select="'New Chart Published'"/></b>
							</p><br/>
						</xsl:when>
						<xsl:otherwise>
							<p style="text-align:left;margin-bottom:0px;margin-top:0px ">
								<b><xsl:value-of select="'New Chart(s) Published'"/></b>
							</p><br/>
						</xsl:otherwise>
					</xsl:choose>
			<table width="100%" style="margin-left:.1in;margin-bottom:0px;margin-top:0px;">
			<tbody>
				<tr>
					<td width="9.6%" style="vertical-align:text-top;"><i>Number</i></td>
					<td width="34.8%" style="vertical-align:text-top;"><i>Title and other remarks</i></td>
					<td width="13.5%" style="vertical-align:text-top;text-align:right;"><i>Scale 1:</i></td>
					<td width="15.5%" style="vertical-align:text-top;padding-left:15px;"><i>Published</i></td>
					<td width="13.1%" style="vertical-align:text-top;color:white;"><i>Notices to Mariners in Force</i></td>
<!--					<td width="13.1%" style="vertical-align:text-top;"><i></i></td>-->
					<!--<td width="14%" style="vertical-align:text-top;"><i>NZ 202 Page</i></td>-->
				</tr>
				<xsl:call-template name="charts-published"/>
			</tbody>
		</table>
				</xsl:otherwise>
			</xsl:choose>
		<!-- ================================================= -->
		<!-- Editions Published Section                        -->
		<!-- ================================================= -->
	
			
			<xsl:choose>
				<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNEP[ancestor::NM_PNC_NEPUB])">
					
				</xsl:when>
				<xsl:otherwise>
				<br/><br/>
					<xsl:variable name="number_of_new_edition_published">
						<xsl:if test ="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNEP[ancestor::NM_PNC_NEPUB]//PPRPAN/@id]">
							<xsl:value-of select="count(//NM_MISC_INSTRUCT_PNCNEP[ancestor::NM_PNC_NEPUB])"/>
						</xsl:if>	
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$number_of_new_edition_published = 1">
							<p style="text-align:left;margin-bottom:0px;margin-top:0px">
								<b><xsl:value-of select="'New Edition Published'"/></b>
							</p><br/>
						</xsl:when>
						<xsl:otherwise>
							<p style="text-align:left;margin-bottom:0px;margin-top:0px">
								<b><xsl:value-of select="'New Edition(s) Published'"/></b>
							</p><br/>
						</xsl:otherwise>
					</xsl:choose>
			

			<table width="100%" style="margin-left:.1in;margin-bottom:0px;margin-top:0px;">
			<tbody>
				<tr>
					<td width="9.6%" style="vertical-align:text-top;"><i>Number</i></td>
					<td width="34.8%" style="vertical-align:text-top;"><i>Title and other remarks</i></td>
					<td width="13.5%" style="vertical-align:text-top;text-align:right;"><i>Scale 1:</i></td>
					<td width="15.5%" style="vertical-align:text-top;padding-left:15px;"><i>Published</i></td>
					<td width="13.1%" style="vertical-align:text-top;"><i>Notices to Mariners in Force</i></td>
					<td width="14%" style="vertical-align:text-top;"><i><!--NZ 202 Page--></i></td>
				</tr>
				<xsl:call-template name="editions-published"/>
			</tbody>
		</table>
				</xsl:otherwise>
			</xsl:choose>
		<!-- ================================================= -->
		<!-- Charts Withdrawn Section                          -->
		<!-- ================================================= -->
		<!--<br/><br/>-->
			
			<xsl:choose>
				<xsl:when test="not(//NM_MISC_INSTRUCT_PNCPW)">
					<br/>	
				</xsl:when>
				<xsl:otherwise>
			<br/><br/>
					<xsl:variable name="number_of_charts_permanently_withdrawn">
						<xsl:if test ="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCPW//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]">
							<xsl:value-of select="count(//NM_MISC_INSTRUCT_PNCPW)"/>
						</xsl:if>	
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$number_of_charts_permanently_withdrawn = 1">
							<p style="text-align:left;margin-bottom:0px;margin-top:0px">	
								<b><xsl:value-of select="'Chart Permanently Withdrawn'"/></b>
							</p><br/>
						</xsl:when>
						<xsl:otherwise>
							<p style="text-align:left;margin-bottom:0px;margin-top:0px">	
								<b><xsl:value-of select="'Chart(s) Permanently Withdrawn'"/></b>
							</p><br/>
						</xsl:otherwise>
					</xsl:choose>
		<div style="margin-left:0.25in;">
			<table>
				<tbody>
					<tr style="height:10px;">
						<td width="8%" style="vertical-align:text-top;"><i>Number</i></td>
						<td width="50%" style="vertical-align:text-top;"><i>Published</i></td>
					</tr>
					<xsl:call-template name="charts-withdrawn"/>
				</tbody>
			</table><br/>
		</div>
				</xsl:otherwise>
			</xsl:choose>
		<xsl:if test="(//NM_MISC_INSTRUCT_PNCPW)">
			<span text-align="justify" style="margin-bottom:0px;margin-top:0px;">Charts listed above as withdrawn no longer meet carriage requirements
				and should be marked as “superseded” and replaced with the new chart/ new edition listed
				prior to passage through the area covered by the new chart.</span><br/><br/>
		</xsl:if>
			

		<span style="font:arial;font-size:9pt;margin-bottom:.0001pt;">
			<xsl:if test="normalize-space(//NM_PNC_PRD/HITS_NUMBER)">
				<xsl:value-of select="'New Zealand Hydrographic Authority'"/>
			</xsl:if>
			<br/>
			<xsl:apply-templates select="//NM_PNC_PRD/HITS_NUMBER"/>
			
			
		</span>
		<!-- ================================================= -->
			
		</xsl:if>
		
		<!--<xsl:if test="(//NM_MISC_INSTRUCT_PNCNCTBP/CHART_LIST/CHART or //NM_MISC_INSTRUCT_PNCNETBP/CHART_LIST/CHART)">
		<!-\- Section II - New Charts to be Published Shortly-\->
		<br/><br/><br/>
			<span style="text-align:left;font-size:9pt;margin-bottom:0px;margin-top:0px;">
			<b><xsl:value-of select="'NEW ZEALAND CHARTS. New Chart, New Editions to be Published Shortly'"/></b>
			</span><br/><br/>
			
			<xsl:choose>
				<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNCTBP/CHART_LIST/CHART)">
					
				</xsl:when>
				<xsl:otherwise>	
		<span style="text-align:left;font-size:9pt;margin-bottom:0px;margin-top:0px;">
			
			<b><xsl:value-of select="'New Chart to be Published Shortly'"/></b>
		</span><br/>

		<!-\- This is the table for new charts to be published shortly-\->
		<table style="width:100%;">
			<tbody>
				<tr style="height:30px;">
					<td width="20%"><i>Number</i></td>
					<td width="80%"><i>Title</i></td>
				</tr>
				<xsl:call-template name="charts-to-be-published"/>
			</tbody>
		</table>
		</xsl:otherwise>
		</xsl:choose>


		<!-\- This is the table for new editions to be published shortly-\->
		<br/><br/>
			<xsl:choose>
				<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNETBP/CHART_LIST/CHART)">	
					
				</xsl:when>
				<xsl:otherwise>
			
			<br/><br/>
			<p style="text-align:left;margin-bottom:0px;margin-top:0px;">
			<b>
				<xsl:value-of select="'New Editions to be Published Shortly'"/>
			</b>
		</p>
		<table style="width:100%">
			<tbody style="width:100%;padding:0;margin:0;border-collapse:collapse;">
				<tr style="height:30px;">
					<td width="20%;"><i>Number</i></td>
					<td width="80%;"><i>Title</i></td>
				</tr>
				<xsl:call-template name="editions-to-be-published"/>
			</tbody>
		</table>
				</xsl:otherwise>
			</xsl:choose>
					<br/>
			<p style="font:arial;font-size:9pt;margin-bottom:0px;margin-top:0px;">
			<xsl:if test="normalize-space(//NM_PNC_PRD_TPUB/HITS_NUMBER)">
				<xsl:value-of select="'New Zealand Hydrographic Authority'"/>
			</xsl:if>
			<br/>
			<xsl:value-of select="//NM_PNC_PRD_TPUB/HITS_NUMBER"/>
				<br/>
				<br/>
		</p>			
		</xsl:if>-->
		<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNCTBP) and not(//NM_MISC_INSTRUCT_PNCNETBP)">
				<br/>	
			</xsl:when>
			<xsl:otherwise>
				<br/><br/>
				<xsl:variable name="number_of_charts_and_editions_to_be_published">
					<xsl:if test ="(//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNCTBP//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]) or //AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNETBP//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]">
						<xsl:value-of select="count(//NM_MISC_INSTRUCT_PNCNCTBP)+ count(//NM_MISC_INSTRUCT_PNCNETBP)"/>
					</xsl:if>	
				</xsl:variable>
					<xsl:if test="$number_of_charts_and_editions_to_be_published != ''">
						<span style="text-align:left;font-size:9pt;margin-bottom:0px;margin-top:0px;">
							<b><xsl:value-of select="'NEW ZEALAND CHARTS. New Charts, New Editions to be Published Shortly'"/></b>
						</span><br/><br/>
					</xsl:if>
				<xsl:choose>
					<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNCTBP)">
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="number_of_charts_to_be_published">
							<xsl:if test ="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNCTBP//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]">
								<xsl:value-of select="count(//NM_MISC_INSTRUCT_PNCNCTBP)"/>
							</xsl:if>	
						</xsl:variable>
						
						<xsl:choose>
							<xsl:when test="$number_of_charts_to_be_published = 1">
								<p style="text-align:left;margin-bottom:0px;margin-top:0px">	
									<b><xsl:value-of select="'New Chart to be Published Shortly'"/></b>
								</p><br/>
							</xsl:when>
							<xsl:otherwise>
								<p style="text-align:left;margin-bottom:0px;margin-top:0px">	
									<b><xsl:value-of select="'New Charts to be Published Shortly'"/></b>
								</p><br/>
							</xsl:otherwise>
						</xsl:choose>
						<!-- This is the table for new charts to be published shortly -->			
						<table style="width:100%;">
							<tbody>
								<tr style="height:30px;">
									<td width="20%"><i>Number</i></td>
									<td width="80%"><i>Title</i></td>
								</tr>
								<xsl:call-template name="charts-to-be-published"/>
							</tbody>
						</table>
					</xsl:otherwise>
				</xsl:choose>
				<br/>
				<xsl:choose>
					<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNETBP)">
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="number_of_editions_to_be_published">
							<xsl:if test ="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNETBP//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]">
								<xsl:value-of select="count(//NM_MISC_INSTRUCT_PNCNETBP)"/>
							</xsl:if>	
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$number_of_editions_to_be_published = 1">
								<p style="text-align:left;margin-bottom:0px;margin-top:0px">	
									<b><xsl:value-of select="'New Edition to be Published Shortly'"/></b>
								</p><br/>
							</xsl:when>
							<xsl:otherwise>
								<p style="text-align:left;margin-bottom:0px;margin-top:0px">	
									<b><xsl:value-of select="'New Editions to be Published Shortly'"/></b>
								</p><br/>
							</xsl:otherwise>
						</xsl:choose>
						<table style="width:100%">
							<tbody style="width:100%;padding:0;margin:0;border-collapse:collapse;">
								<tr style="height:30px;">
									<td width="20%;"><i>Number</i></td>
									<td width="80%;"><i>Title</i></td>
								</tr>
								<xsl:call-template name="editions-to-be-published"/>
							</tbody>
						</table>
					</xsl:otherwise>
				</xsl:choose>
				<br/><br/>
				<p style="font:arial;font-size:9pt;margin-bottom:0px;margin-top:0px;">
					<xsl:if test="normalize-space(//NM_PNC_PRD_TPUB/HITS_NUMBER)">
						<xsl:value-of select="'New Zealand Hydrographic Authority'"/>
					</xsl:if>
					<br/>
					<xsl:value-of select="//NM_PNC_PRD_TPUB/HITS_NUMBER"/>
					<br/>
					<br/>
				</p>	
			</xsl:otherwise>
		</xsl:choose>
		

		<!-- section header before to BSB update section -->
		<!--<xsl:call-template name="section-header">
			<xsl:with-param name="section-number" select="'II'"/>
		</xsl:call-template>-->
		
		
		<xsl:choose>
			<xsl:when test="//NM_BSB_PRD/NM_RNC_LIST= 'BSB_Update'">
				<span style="margin-bottom:6pt;">
					<b>NEW ZEALAND CHARTS. Raster Navigational Charts (RNCs) BSB Update File</b>
				</span><br/><br/>
				
				<p style="text-align:left;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">
					<xsl:apply-templates select="//NM_BSB_PRD/NM_CONTENT_COMP/NM_CONTENT"/>
					<br/></p>				
				
				<!--<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">From 10 November 2017, the <i>NZMariner</i> BSB cumulative update file for October 2017 will be available from the LINZ website: <a href="https://www.linz.govt.nz/sea/charts/nzmariner-official-raster-navigational-charts-rncs">https://www.linz.govt.nz/sea/charts/nzmariner-official-raster-navigational-charts-rncs. </a></p>
				<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;"><i>NZMariner</i> Raster Navigational Charts (RNCs) can be used only in conjunction with compatible viewing software called Electronic Charting Systems (ECS). </p>
				<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">For compliance with New Zealand legal requirements for nautical charts and publications please refer to Maritime Rules Part 25, available from the Maritime New Zealand website: <a href="https://www.maritimenz.govt.nz/rules/part-25/">https://www.maritimenz.govt.nz/rules/part-25/.</a> </p>
				<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">                                                          
					Further details are included in the Annual New Zealand Notices to Mariners, No.1 which can be found in the New Zealand Nautical Almanac (NZ 204) and on the LINZ website: <a href="https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204">https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204.</a>  </p><br/>-->
			</xsl:when>
			<xsl:when test="//NM_BSB_PRD/NM_RNC_LIST= 'BSB_Base'">
				<span style="margin-bottom:6pt;">
					<b>NEW ZEALAND PUBLICATIONS. Raster Navigational Charts (RNCs) Annual BSB Base File</b>
				</span><br/><br/>
				
				<p style="text-align:left;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">
			<!--	<xsl:value-of select="//NM_BSB_PRD/NM_CONTENT_COMP/NM_CONTENT"/>-->
					<xsl:apply-templates select="//NM_BSB_PRD/NM_CONTENT_COMP/NM_CONTENT"/>
					<br/></p>
				
				<!--<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">From 10 November 2017, the <i>NZMariner</i> 2017/18 annual BSB base file (updated to Notices to Mariners Edition 13, 2017) will be available from the LINZ website: <a href="https://www.linz.govt.nz/sea/charts/nzmariner-official-raster-navigational-charts-rncs">https://www.linz.govt.nz/sea/charts/nzmariner-official-raster-navigational-charts-rncs.</a> </p>
				<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;"><i>NZMariner</i> Raster Navigational Charts (RNCs) can be used only in conjunction with compatible viewing software called Electronic Charting Systems (ECS). </p>
				<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">For compliance with New Zealand legal requirements for nautical charts and publications please refer to Maritime Rules Part 25, available from the Maritime New Zealand website: <a href="https://www.maritimenz.govt.nz/rules/part-25/">https://www.maritimenz.govt.nz/rules/part-25/.</a> </p>
				<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">
					Further details are included in the Annual New Zealand Notices to Mariners, No.1 which can be found in the New Zealand Nautical Almanac (NZ 204) and on the LINZ website: <a href="https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204">https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204.</a> </p><br/>-->
			</xsl:when>
			<xsl:when test="//NM_BSB_PRD/NM_RNC_LIST= 'Both'">
				<div style="text-align: justify"><span style="margin-bottom:0px;margin-top:0px;">
					<span style="margin-bottom:6pt;">
						<b>NEW ZEALAND CHARTS. Raster Navigational Charts (RNCs) BSB Update File</b>
					</span><br/><br/>
					
					<span style="text-align:left;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">
					<!--<xsl:value-of select="//NM_BSB_PRD/NM_CONTENT_COMP/NM_CONTENT"/>-->
						<xsl:apply-templates select="//NM_BSB_PRD/NM_CONTENT_COMP/NM_CONTENT"/>
						<br/></span>
					
					<!--<xsl:value-of select="//NM_BSB_PRD/NM_RNC_LIST"/>
					<br/>-->
					
					<!--<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">From 10 November 2017, the <i>NZMariner</i> BSB cumulative update file for October 2017 will be available from the LINZ website: <a href="https://www.linz.govt.nz/sea/charts/nzmariner-official-raster-navigational-charts-rncs">https://www.linz.govt.nz/sea/charts/nzmariner-official-raster-navigational-charts-rncs. </a></p>
					<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;"><i>NZMariner</i> Raster Navigational Charts (RNCs) can be used only in conjunction with compatible viewing software called Electronic Charting Systems (ECS). </p>
					<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">For compliance with New Zealand legal requirements for nautical charts and publications please refer to Maritime Rules Part 25, available from the Maritime New Zealand website: <a href="https://www.maritimenz.govt.nz/rules/part-25/">https://www.maritimenz.govt.nz/rules/part-25/.</a> </p>
					<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">
						Further details are included in the Annual New Zealand Notices to Mariners, No.1 which can be found in the New Zealand Nautical Almanac (NZ 204) and on the LINZ website: <a href="https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204">https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204.</a>  </p><br/><br/>-->
					<span style="margin-bottom:6pt;">
						<b>NEW ZEALAND PUBLICATIONS. Raster Navigational Charts (RNCs) Annual BSB Base File</b>
					</span><br/><br/>
					
					<p style="text-align:left;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">
					<!--<xsl:value-of select="//NM_BSB_PRD/NM_CONTENT_COMP/NM_CONTENT"/>-->
						<xsl:apply-templates select="//NM_BSB_PRD/NM_CONTENT_COMP/NM_CONTENT"/>
						<br/></p>
					
					<!--<xsl:value-of select="//NM_BSB_PRD/NM_RNC_LIST"/>
					<br/>-->
					<!--<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">From 10 November 2017, the <i>NZMariner</i> 2017/18 annual BSB base file (updated to Notices to Mariners Edition 13, 2017) will be available from the LINZ website: <a href="https://www.linz.govt.nz/sea/charts/nzmariner-official-raster-navigational-charts-rncs">https://www.linz.govt.nz/sea/charts/nzmariner-official-raster-navigational-charts-rncs.</a> </p>
					<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;"><i>NZMariner</i> Raster Navigational Charts (RNCs) can be used only in conjunction with compatible viewing software called Electronic Charting Systems (ECS). </p>
					<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">For compliance with New Zealand legal requirements for nautical charts and publications please refer to Maritime Rules Part 25, available from the Maritime New Zealand website: <a href="https://www.maritimenz.govt.nz/rules/part-25/">https://www.maritimenz.govt.nz/rules/part-25/.</a> </p>
					<p style="text-align:justify;font:arial;font-size:9pt;margin-bottom:6pt;margin-top:6pt;">
						Further details are included in the Annual New Zealand Notices to Mariners, No.1 which can be found in the New Zealand Nautical Almanac (NZ 204) and on the LINZ website: <a href="https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204">https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204.</a> </p><br/>-->
				</span></div><br/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="//NM_BSB_PRD/NM_RNC_LIST !=''">
			<span style="font:arial;font-size:9pt;margin-bottom:0px;margin-top:0px">
			<xsl:if test="normalize-space(//NM_BSB_PRD/HITS_NUMBER)">
				<xsl:value-of select="'New Zealand Hydrographic Authority'"/>
			</xsl:if>
			<br/>
			<xsl:value-of select="//NM_BSB_PRD/HITS_NUMBER"/>
		</span><br/>
		</xsl:if>
		
		<!-- Section II - Electronic Navigation Charts ENCs Published-->
		<xsl:variable name="no-of-encs">
			<xsl:text>ENC</xsl:text>
			<xsl:if test="count(//NM_MISC_INSTRUCT_ENC[ancestor::NM_ENC_PUB]) > 1">
				<xsl:text>s</xsl:text>
			</xsl:if>
		</xsl:variable>
		<br/><br/>		
		
		<!-- This is for NEW ZEALAND CHARTS. New Electronic Navigation Chart(s) Published, Withdrawn ENC(s) Heading -->
		<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_ENC[ancestor::NM_ENC_PUB])">
				
			</xsl:when>
			<xsl:otherwise>
		<div style="margin-bottom:10px;margin-top:0px;">
		<span style="text-align:left;margin-bottom:0px;margin-top:0px;">
			<b>
				<xsl:value-of select="concat('NEW ZEALAND CHARTS. New Electronic Navigation Chart(s) (',$no-of-encs,') Published, Withdrawn ENC(s)')"
				/>
			</b>
		</span>
		</div>

		<!-- This is the table for electronic navigation charts -->
		<table style="width:100%;padding:0;margin:0;border-collapse:collapse;margin-top:0px;">
			<tbody>
				<tr style="height:30px;">
					<td width="12%"><i>Number</i></td>
					<td width="75%"><i>Title</i></td>
					<td width="15%"><i>Published</i></td>
				</tr>
				<xsl:call-template name="electronic-navigational-charts"/>
			</tbody>
		</table><br/>
		
		<p style="margin-bottom:0px;margin-top:0px;"><b>README.TXT File</b><br/> The README.TXT file located within
			the ENC_ROOT folder of an ENC exchange set contains important safety related information.
			This file is updated on a regular basis and should be consulted to ensure that all related
			issues are taken into consideration. The latest README.TXT file is also located on the LINZ
			website <br/><a
				href="https://www.linz.govt.nz/sea/charts/information-about-charts#enc"
				>www.linz.govt.nz/sea/charts/information-about-charts#enc</a>. </p><br/>
				<p style="margin-bottom:0px;margin-top:0px;"><b>Use of Electronic Navigational Charts </b><br/>For compliance with New Zealand legal requirements for nautical charts and publications please refer to <i>Maritime Rules Part 25</i>, available from the Maritime New Zealand website: <a href="https://www.maritimenz.govt.nz/rules/part-25/">https://www.maritimenz.govt.nz/rules/part-25/.</a></p><br/>
		
			</xsl:otherwise>
		</xsl:choose>
		
		<span style="font:arial;font-size:9pt;margin-bottom:0px;margin-top:0px;">
			<xsl:if test="normalize-space(//HITS_NUMBER[ancestor::NM_ENC_PUB[ancestor::NM_ENC_PRD]])">
				<xsl:value-of select="'New Zealand Hydrographic Authority'"/>
			</xsl:if>
			<br/>
			<xsl:value-of select="//HITS_NUMBER[ancestor::NM_ENC_PUB[ancestor::NM_ENC_PRD]]"/>
		</span>

		<!-- Section II - Electronic Navigation Charts - To be published-->
		<br/><br/><!--<br/>-->
		
		<!-- ================================================= -->
		<!-- ENCs Withdrawn Section                          -->
		<!-- ================================================= -->
		<xsl:variable name="encw-count">
			<xsl:text>ENC</xsl:text>
			<xsl:if test="count(//NM_MISC_INSTRUCT_ENCPW) > 1">
				<xsl:text>(s) </xsl:text>
			</xsl:if>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_ENCPW)">
				
			</xsl:when>
			<xsl:otherwise>
		<xsl:choose>
			<xsl:when test="count(//NM_MISC_INSTRUCT_ENCPW) > 1">
				<span style="text-align:left; margin-bottom:0px;margin-top:0px;">
					<b><xsl:value-of select="concat($encw-count,'Permanently Withdrawn')"/></b>
					<!--<b><xsl:text>ENC(s) Permanently Withdrawn</xsl:text></b>-->
				</span>
				<div style="margin-left:0.25in;">
					<table style="width:100%;">
						<tbody>
							<tr style="height:10px;">
								<td width="8%" style="vertical-align:text-top;"><i>Number</i></td>
								<td width="22%" style="vertical-align:text-top;"><i>On Publication of ENC Cell</i></td>
								<td width="32%" style="vertical-align:text-top;"><i>Published</i></td>
							</tr>
							<xsl:call-template name="encs-withdrawn"/>
						</tbody>
					</table>
				</div><br/>
			</xsl:when>
			<xsl:otherwise>
				<b><xsl:value-of select="concat($encw-count,' Permanently Withdrawn')"/></b>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="count(//NM_MISC_INSTRUCT_ENCPW) > 1">
		
			</xsl:when>
			<xsl:otherwise>
				<!--it should be empty-->
				<div style="margin-left:0.25in;">
					<table style="width:100%;">
						<tbody>
							<tr style="height:10px;">
								<td width="8%" style="vertical-align:text-top;"><i>Number</i></td>
								<td width="22%" style="vertical-align:text-top;"><i>On Publication of ENC Cell</i></td>
								<td width="32%" style="vertical-align:text-top;"><i>Published</i></td>
							</tr>
							<xsl:call-template name="encs-withdrawn"/>
						</tbody>
					</table>
				</div><br/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="normalize-space(//NM_ENCPW/COMMENT)">
			<p text-align="justify" style="margin-bottom:10px;margin-top:10px;"><xsl:value-of select="//NM_ENCPW/COMMENT"/></p>
		</xsl:if>
		
		<p style="font:arial;font-size:9pt;margin-bottom:0px;margin-top:0px;">
			<xsl:if test="normalize-space(//NM_ENCPW/HITS_NUMBER)">
				<xsl:value-of select="'New Zealand Hydrographic Authority'"/>
			</xsl:if>
			<br/>
			<xsl:apply-templates select="//NM_ENCPW/HITS_NUMBER"/>
		</p>
				<!--<br/>-->
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- ================================================= -->

		<!-- Section II - Nautical Almanac (editions published)-->
		<!--<xsl:call-template name="section-header">
			<xsl:with-param name="section-number" select="'II'"/>
		</xsl:call-template>-->
		<xsl:if test="//NM_DISPLAY_ALMANAC_PUB = 'Yes'">
		<span style="text-align:left;font:arial;font-size:9pt;">
			<b><xsl:value-of select="'NEW ZEALAND PUBLICATIONS. New Zealand Nautical Almanac'"/></b>
		</span><br/><br/>
		<span style="text-align:left;font:arial:font-size:9pt;">
			<b><xsl:value-of select="'New Edition Published'"/></b>
		</span>
		<table style="width:100%;margin-left:.1in">
			<tbody>
				<tr style="height:30px;">
					<td width="10%"><i>Number</i></td>
					<td width="90%"><i>Title and other remarks</i></td>
				</tr>
				<tr>
					<td style="vertical-align:text-top;">
						<b>NZ 204</b>
					</td>
					<td style="vertical-align:text-top;">
						<b>New Zealand Nautical Almanac 2018/19 Edition</b>
						<br/><br/>
						<span style="font:arial:font-size:9pt;margin-top:10px;margin-bottom:8px;">This Edition covers the period 1 July 2018 to 30 June 2019 and includes: updated
							Annual <br/>Notices to Mariners (ANTM), tidal predictions, the New Zealand Light List and
							data for the rising <br/>and setting of the sun, moon and planets for New Zealand.</span><br/><br/>
						<span style="font:arial:font-size:9pt;margin-top:10px;margin-bottom:8px;">Corrections accrued whilst this publication was at press are issued in Section V of
							this <br/>fortnightly edition.</span><br/><br/>
						<span style="font:arial:font-size:9pt;margin-top:10px;margin-bottom:0px;">Note that the updated information is available also on the website: <br/><a
							href="https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204"
							>https://www.linz.govt.nz/sea/nautical-information/new-zealand-nautical-almanac-nz-204</a>.
						</span>
					</td>
				</tr>
			</tbody>
		</table>

		<!-- Section II - Nautical Almanac (publications to be cancelled)-->
		<xsl:if test="(//NM_PUB_CAN_COMP[ancestor::NM_PUB_CAN])">
			<br/><br/>
			<span style="text-align:left;margin-top:0px;margin-bottom:0px;">
				<xsl:choose>
					<xsl:when test="count(//NM_PUB_CAN_COMP[ancestor::NM_PUB_CAN]) = 1">
						<b><xsl:value-of select="'Publication to be Cancelled'"/></b>
					</xsl:when>
					<xsl:when test="count(//NM_PUB_CAN_COMP[ancestor::NM_PUB_CAN]) > 1">
						<b><xsl:value-of select="'Publications to be Cancelled'"/></b>
					</xsl:when>
				</xsl:choose>
			</span>
			<table style="width:100%;margin-left:.1in">
				<tbody>
					<tr style="height:30px;">
						<td width="10%"><i>Number</i></td>
						<td width="90%"><i>Title and other remarks</i></td>
					</tr>
					<xsl:call-template name="publications-to-be-cancelled"/>
				</tbody>
			</table>
			<span style="font:arial;font-size:9pt;margin-bottom:0px;margin-top:0px;">
				<xsl:if test="normalize-space(//HITS_NUMBER[ancestor::NM_PUB_PRD])">
					<br/><xsl:value-of select="'New Zealand Hydrographic Authority'"/>
				</xsl:if>
				<br/>
				<xsl:value-of select="//HITS_NUMBER[ancestor::NM_PUB_PRD]"/>
				<br/>
			</span>
		</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- This is the template for charts withdrawn-->
	<xsl:template name="charts-withdrawn">
		<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_PNCPW)">
				<tr><td style="font:arial;font-size:9pt;">Nil</td></tr>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCPW//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]">
					<xsl:sort select="normalize-space(translate(CHTNUM,'NZ',''))" data-type="number" order="ascending"/>
		<tr style="margin-top:0px;margin-bottom:0px;">
			<td>
				<b>
								<xsl:if test="normalize-space(translate(CHTNUM,'NZ ',''))">
									<xsl:value-of select="concat(substring(CHTNUM,1,2),' ',substring(CHTNUM,3,15))"/>
									<xsl:if test="normalize-space(INTNUM ) != '' ">
										<xsl:text> (</xsl:text>										
										<xsl:value-of select="normalize-space(INTNUM)"/>
										<xsl:text>)</xsl:text>
									</xsl:if>
								</xsl:if>
							</b>
			</td>
			<xsl:variable name="current_id">
				<xsl:value-of select="CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id"/>
			</xsl:variable>
			<xsl:for-each select="//NM_MISC_INSTRUCT_PNCPW//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN">
				<xsl:if test="@id = $current_id">
				<td><xsl:value-of select="../../..//NZ_CHART_PUB"/></td>
				</xsl:if>
			</xsl:for-each>
		</tr>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="encs-withdrawn">
		<!--<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_ENCPW)">
				<tr><td style="font:arial;font-size:9pt;">NIL</td></tr>
			</xsl:when>
			<xsl:otherwise>-->
				<xsl:for-each select="//NM_MISC_INSTRUCT_ENCPW">
					<tr>
						<td>
							<xsl:if test="normalize-space(ENC_NAME)">
								<b><xsl:value-of select="ENC_NAME"/></b>
								<!--<b><xsl:value-of select="concat(substring(ENC_NAME,1,2),' ',substring(ENC_NAME,3,15))"/></b>-->
							</xsl:if>
						</td>
						<td><xsl:if test="normalize-space(ENC_NEW_EDITION)">
							<xsl:value-of select="ENC_NEW_EDITION"/>
							<!--<xsl:value-of select="concat(substring(ENC_NEW_EDITION,1,2),' ',substring(ENC_NEW_EDITION,3,15))"/>-->
						</xsl:if></td>
						<td><xsl:value-of select="NZ_CHART_PUB"/></td>
					</tr>
				</xsl:for-each>
			<!--</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>
	
	<!-- This is the template for charts published-->
	<xsl:template name="charts-published">
        <!-- iterate over all the affected charts which are linked to instructions in the misc notices section, sorted by number -->
        <xsl:for-each select="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNCP//PPRPAN/@id]">
        <xsl:sort select="normalize-space(translate(CHTNUM,'NZ',''))" data-type="number" order="ascending"/>
            <xsl:variable name="chart" select="."/>
            <xsl:variable name="instruct" select="//NM_MISC_INSTRUCT_PNCNCP[//PPRPAN/@id= $chart//PPRPAN/@id ]"/>
            <xsl:variable name="mainPanel" select=".//PPRPAN[PANNAM = $chart/CTITL1]"/>
             
            <tr>
				<td style="vertical-align:text-top;width:6%;">
                    <b>
                    <xsl:if test="normalize-space(translate(CHTNUM,'NZ ',''))">
                        <!--<xsl:value-of select="CHTNUM"/>-->
                    	<xsl:value-of select="concat(substring(CHTNUM,1,2),' ',substring(CHTNUM,3,15))"/>
                        <xsl:if test="normalize-space(INTNUM ) != '' ">
                            <xsl:text> (</xsl:text>										
                            <xsl:value-of select="normalize-space(INTNUM)"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </xsl:if>
                    </b>
                </td>
                <td style="vertical-align:text-top;width:6%;margin-top:0px;margin-bottom:0px">
                    <!-- Chart title and remarks CTITL1 -->
                    <b><xsl:value-of select="normalize-space(CTITL1)"/></b>
                    <!--<p><i><xsl:value-of select="$instruct/NZ_CHART_REMARKS"/></i></p>
                	<p><i><xsl:value-of select="NZ_CHART_REMARKS"/></i></p>-->
                	
                	<!--<xsl:for-each select="../..//INSTRUCTION_LIST/INSTRUCTION_LIST_ITEM/NM_MISC_INSTRUCT_PNCNCP//PPRPAN">
                		<xsl:if test="@id = $chart//PPRPAN/@id">
                				<p><i><xsl:value-of select="../../..//NZ_CHART_REMARKS"/></i></p>
                		</xsl:if>
                	</xsl:for-each>-->
                	<xsl:for-each select="../..//INSTRUCTION_LIST/INSTRUCTION_LIST_ITEM/NM_MISC_INSTRUCT_PNCNCP//PPRPAN[@id = $chart//PPRPAN/@id]">
                		<xsl:if test="position() = 1">
                			<p><i><xsl:value-of select="../../..//NZ_CHART_REMARKS"/></i></p>
                		</xsl:if>
                	</xsl:for-each>
                	
                    <xsl:if test="$mainPanel">
                            <br/>
                            <xsl:variable name="bndMax" >
                                <xsl:choose>
                                    <xsl:when test="$mainPanel/BOUNDARY_MAX/gml:Point/gml:pos != ''">
                                        <xsl:value-of select="$mainPanel/BOUNDARY_MAX/gml:Point/gml:pos"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$mainPanel/BOUNDARY_MAX//*/text()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="bndMin" >
                                <xsl:choose>
                                    <xsl:when test="$mainPanel/BOUNDARY_MIN/gml:Point/gml:pos != ''">
                                        <xsl:value-of select="$mainPanel/BOUNDARY_MIN/gml:Point/gml:pos"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$mainPanel/BOUNDARY_MIN//*/text()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>

							<!-- max Y -->
							<xsl:call-template name="LatDDtoDDM">
								<xsl:with-param name="Coordinate" select="substring-before($bndMax,' ')"/>
								<xsl:with-param name="scale" select="$mainPanel/PSCALE"></xsl:with-param>
							</xsl:call-template>
							<xsl:text> - </xsl:text>
							<!-- min Y -->
							<xsl:call-template name="LatDDtoDDM">
								<xsl:with-param name="Coordinate" select="substring-before($bndMin,' ')"/>
								<xsl:with-param name="scale" select="$mainPanel/PSCALE"></xsl:with-param>
							</xsl:call-template>
                            <br/>
							<!-- min X -->
							<xsl:call-template name="LonDDtoDDM">
								<xsl:with-param name="Coordinate" select="substring-after($bndMin,' ')"/>
								<xsl:with-param name="scale" select="$mainPanel/PSCALE"></xsl:with-param>
							</xsl:call-template>
							<xsl:text> - </xsl:text>
							<!-- max X -->
							<xsl:call-template name="LonDDtoDDM">
								<xsl:with-param name="Coordinate" select="substring-after($bndMax,' ')"/>
								<xsl:with-param name="scale" select="$mainPanel/PSCALE"></xsl:with-param>
							</xsl:call-template>
                            <br/>
                    </xsl:if>
                </td>
                <td style="vertical-align:text-top; width:5px;text-align:right;margin-top:0px;margin-bottom:0px">
                	<!--<xsl:text> $mainPanel/PSCALE </xsl:text>
                	<xsl:value-of select="$mainPanel/PSCALE"/>
                	<xsl:text> *** </xsl:text>-->
                <!-- Chart scale of main panel -->
                	<xsl:choose>
                		<xsl:when test="$mainPanel/PSCALE != ''">
                			<xsl:value-of select="format-number($mainPanel/PSCALE,'### ###','scale')"/>
                		</xsl:when>
                		<xsl:otherwise>
                			<!-- keep it empty -->
                		</xsl:otherwise>
                	</xsl:choose>
                	
                </td>
				<td style="vertical-align:text-top;width:18%;padding-left:15px;">
					<!--<xsl:text> id </xsl:text>
					<xsl:value-of select="$mainPanel/@id"/>
					<xsl:text> *** </xsl:text>-->
<!--					<xsl:variable name="current_id">-->
					<xsl:choose>
						<xsl:when test=" $mainPanel/@id != ''">
							<xsl:for-each select="$mainPanel/@id">
								<!--<xsl:value-of select="."/>-->
								<xsl:for-each select="key('charts_id', .)">
									<xsl:value-of select="NZ_CHART_PUB"/>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select=".//PPRPAN[PANNAM]/@id">
								<xsl:if test="position() = 1">
									<xsl:for-each select="key('charts_id', .)">
									<xsl:value-of select="NZ_CHART_PUB"/>
								</xsl:for-each>
								</xsl:if>
							</xsl:for-each>
							<!--<xsl:value-of select=".//PPRPAN[PANNAM]/@id"/>
							<xsl:text> *** </xsl:text>-->
						</xsl:otherwise>
					</xsl:choose>
						<!--<xsl:value-of select="CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id"/>-->
					<!--</xsl:variable>--><!--
					<xsl:value-of select="$mainPanel/@id"/>
					<xsl:text> @@@ </xsl:text>
					<xsl:value-of select="$current_id"/>
					<xsl:text> *** </xsl:text>-->
<!--					<xsl:for-each select="//NM_MISC_INSTRUCT_PNCNCP[//PPRPAN/@id= $current_id]">-->
					<!--<xsl:for-each select="//NM_MISC_INSTRUCT_PNCNCP[//PPRPAN/@id]">
						<xsl:value-of select="INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM//PPRPAN/@id"/>
						<xsl:for-each select="//INSTRUCTION_PANEL_LIST">
							<xsl:text> values </xsl:text>
							<xsl:value-of select="/INSTRUCTION_PANEL_LIST_ITEM//PPRPAN/@id"/>
						</xsl:for-each>
						<xsl:text> IN </xsl:text>
						<xsl:value-of select="NZ_CHART_PUB"/>
						<xsl:text> *** </xsl:text>
						<xsl:if test=". = $current_id">
<!-\-						<xsl:if test="position() = 1">-\->
							<xsl:value-of select="NZ_CHART_PUB"/>
						</xsl:if>
						<!-\-</xsl:if>-\->
					</xsl:for-each>-->
					<!--<xsl:value-of select="//NM_MISC_INSTRUCT_PNCNCP[//PPRPAN/@id= $chart//PPRPAN/@id ]/NZ_CHART_PUB"/>-->
                    <!-- Used to use value from notice instructions but seems redundant so using Edition date from actual chart -->
                    <!--<xsl:call-template name="format">
                        <xsl:with-param name="datestr" select="EDDATE"></xsl:with-param>
                    </xsl:call-template>-->
				</td>
				<td style="vertical-align:text-top;width:15%;">
					<xsl:value-of select="$instruct/NZ_NOTICE_IN_FORCE"/>
				</td>
            </tr>
            <!-- Make a separate row with just title and scale for each additional panel -->
            <xsl:for-each select=".//PPRPAN[PANNAM != $chart/CTITL1]">
            <xsl:sort select="PSCALE" data-type="number" order="descending"/>
             <xsl:choose>
             	<xsl:when test="contains(PANNAM,'Source Data') or contains(PANNAM,'NTM')  or contains(PANNAM,'Source Data Panel') or contains(PANNAM,'BSB raster') or contains(PANNAM,'SDD') or contains(PANNAM,'Sourcr Data') or contains(PANNAM,'Source Data Pannel')  or contains(PANNAM,'NTM Panel') or contains(PANNAM,'BSB raster Source Data') or contains(PANNAM,'BSB raster NTM Panel') or contains(PANNAM,'NtM') or contains(PANNAM,'NtM Panel') or contains(PANNAM,'NTM panel') or contains(PANNAM,'Source') or contains(PANNAM,'Source') or contains(PANNAM,'Source Data Panel') or contains(PANNAM,'NTM') or contains(PANNAM,'NM panel') or contains(PANNAM,'souce Data Panel')">
             		<!-- THIS DATA WILL NOT BE SHOWN -->
             	</xsl:when>
             	<xsl:otherwise>
             		<tr>
             			<td/>
             			<td><b><xsl:value-of select="normalize-space(PANNAM)"/></b>
             				<br/>
             				<xsl:variable name="bndMax" >
             					<xsl:choose>
             						<xsl:when test="BOUNDARY_MAX/gml:Point/gml:pos != ''">
             							<xsl:value-of select="BOUNDARY_MAX/gml:Point/gml:pos"/>
             						</xsl:when>
             						<xsl:otherwise>
             							<xsl:value-of select="BOUNDARY_MAX//*/text()"/>
             						</xsl:otherwise>
             					</xsl:choose>
             				</xsl:variable>
             				<xsl:variable name="bndMin" >
             					<xsl:choose>
             						<xsl:when test="BOUNDARY_MIN/gml:Point/gml:pos != ''">
             							<xsl:value-of select="BOUNDARY_MIN/gml:Point/gml:pos"/>
             						</xsl:when>
             						<xsl:otherwise>
             							<xsl:value-of select="BOUNDARY_MIN//*/text()"/>
             						</xsl:otherwise>
             					</xsl:choose>
             				</xsl:variable>
             				<!-- max Y -->
             				<xsl:call-template name="LatDDtoDDM">
             					<xsl:with-param name="Coordinate" select="substring-before($bndMax,' ')"/>
             					<xsl:with-param name="scale" select="PSCALE"/>
             				</xsl:call-template>
             				<xsl:text> - </xsl:text>
             				<!-- min Y -->
             				<xsl:call-template name="LatDDtoDDM">
             					<xsl:with-param name="Coordinate" select="substring-before($bndMin,' ')"/>
             					<xsl:with-param name="scale" select="PSCALE"/>
             				</xsl:call-template>
             				<br/>
             				<!-- min X -->
             				<xsl:call-template name="LonDDtoDDM">
             					<xsl:with-param name="Coordinate" select="substring-after($bndMin,' ')"/>
             					<xsl:with-param name="scale" select="PSCALE"/>
             				</xsl:call-template>
             				<xsl:text> - </xsl:text>
             				<!-- max X -->
             				<xsl:call-template name="LonDDtoDDM">
             					<xsl:with-param name="Coordinate" select="substring-after($bndMax,' ')"/>
             					<xsl:with-param name="scale" select="PSCALE"/>
             				</xsl:call-template>
             				<br/><br/>
             			</td>
             			<td style="vertical-align:text-top; width:5px;text-align:right;margin-top:0px;margin-bottom:0px">
             				<xsl:value-of select="format-number(PSCALE,'### ###','scale')"/>
             			</td>
             			<td/>
             			<td/>
             		</tr>
             	</xsl:otherwise>
             </xsl:choose>
           </xsl:for-each>
        </xsl:for-each>
    
    </xsl:template>

	<!-- This is the template for editions published-->
	<xsl:template name="editions-published">
        <!-- iterate over all the affected charts which are linked to instructions in the misc notices section, sorted by number -->
        <xsl:for-each select="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNEP[ancestor::NM_PNC_NEPUB]//PPRPAN/@id]">
        <xsl:sort select="normalize-space(translate(CHTNUM,'NZ',''))" data-type="number" order="ascending"/>
            <xsl:variable name="chart" select="."/>
            <xsl:variable name="instruct" select="//NM_MISC_INSTRUCT_PNCNEP[ancestor::NM_PNC_NEPUB][//PPRPAN/@id= $chart//PPRPAN/@id ]"/>
        	<xsl:variable name="mainPanel" select=".//PPRPAN[PANNAM = $chart/CTITL1]"/>
                
            <tr style="vertical-align:text-top;width:6%;">
				<td style="vertical-align:text-top;width:6%;">
                    <xsl:if test="normalize-space(translate(CHTNUM,'NZ ',''))">
                        <b>
                        <!--<xsl:value-of select="CHTNUM"/>-->
                        	<xsl:value-of select="concat(substring(CHTNUM,1,2),' ',substring(CHTNUM,3,15))"/>
                        <xsl:if test="normalize-space(INTNUM ) != '' ">
                            <xsl:text> (</xsl:text>										
                            <xsl:value-of select="normalize-space(INTNUM)"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                        </b>
                    </xsl:if>
                </td>
                <td style="vertical-align:text-top;width:6%;margin-top:0px;margin-bottom:0px">
                    <!-- Chart title and remarks CTITL1 -->
                    <b><xsl:value-of select="normalize-space(CTITL1)"/></b>
                    <p><i><xsl:value-of select="$instruct/NZ_CHART_REMARKS"/></i></p>
                </td>
                <td style="vertical-align:text-top; width:5px;text-align:right;margin-top:0px;margin-bottom:0px">
                <!-- Chart scale of main panel -->
                	<xsl:choose>
                		<xsl:when test=".//PPRPAN[PANNAM = $chart/CTITL1]/PSCALE != ''">
                			<xsl:value-of select="format-number(.//PPRPAN[PANNAM = $chart/CTITL1]/PSCALE,'### ###','scale')"/>
                		</xsl:when>
                	<xsl:otherwise>
                		<!-- keep it empty -->
                	</xsl:otherwise>
                	</xsl:choose>
                   
                </td>
				<td style="vertical-align:text-top;width:18%;padding-left:15px;">
					<!-- <xsl:value-of select="$instruct/NZ_CHART_PUB"/> -->
                    <!-- Used to use value from notice instructions but seems redundant so using Edition date from actual chart -->
                    <!--<xsl:call-template name="format">
                        <xsl:with-param name="datestr" select="EDDATE"></xsl:with-param>
                    </xsl:call-template>-->
					<!--<xsl:for-each select="../..//INSTRUCTION_LIST/INSTRUCTION_LIST_ITEM/NM_MISC_INSTRUCT_PNCNEP[//PPRPAN/@id = $chart//PPRPAN/@id]">
						<xsl:if test="position() = 1">
							<xsl:value-of select="../../..//NZ_CHART_PUB"/>
						</xsl:if>
					</xsl:for-each>-->
					<xsl:choose>
						<xsl:when test=" $mainPanel/@id != ''">
							<xsl:for-each select="$mainPanel/@id">
								<!--<xsl:value-of select="."/>-->
								<xsl:for-each select="key('editions_id', .)">
									<xsl:value-of select="NZ_CHART_PUB"/>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select=".//PPRPAN[PANNAM]/@id">
								<xsl:if test="position() = 1">
									<xsl:for-each select="key('editions_id', .)">
										<xsl:value-of select="NZ_CHART_PUB"/>
									</xsl:for-each>
								</xsl:if>
							</xsl:for-each>
							<!--<xsl:value-of select=".//PPRPAN[PANNAM]/@id"/>
							<xsl:text> *** </xsl:text>-->
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td style="vertical-align:text-top;width:15%;">
					<xsl:value-of select="$instruct/NZ_NOTICE_IN_FORCE"/>
				</td>
            </tr>
            <!-- Make a separate row with just title and scale for each additional panel -->
        	<xsl:for-each select=".//PPRPAN[PANNAM != $chart/CTITL1]">
        	<xsl:sort select="PSCALE" data-type="number" order="descending"/>
        	<xsl:choose>
        		<xsl:when test="contains(PANNAM,'Source Data') or contains(PANNAM,'NTM Panel')  or contains(PANNAM,'Source Data Panel')">
        			<!-- THIS DATA WILL NOT BE SHOWN -->
        		</xsl:when>
        	<xsl:otherwise>
             <tr>
                 <td/>
                 <td>
                    <b><xsl:value-of select="normalize-space(PANNAM)"/></b>
                 </td>
                 <td style="vertical-align:text-top; width:5px;text-align:right;margin-top:0px;margin-bottom:0px">
                    <xsl:value-of select="format-number(PSCALE,'### ###','scale')"/>
                 </td>
                 <td/>
                 <td/>
             </tr><!--<br/>-->
        		
        	</xsl:otherwise>
        	</xsl:choose>
        	</xsl:for-each>
        </xsl:for-each>
    
    </xsl:template>
	
	

	<!-- Template for chart to be published -->
	<!--<xsl:template name="charts-to-be-published">
		<!-\-<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNCTBP/CHART_LIST/CHART)">
				<tr><td style="font:arial;font-size:9pt;">NIL</td></tr>
			</xsl:when>
			<xsl:otherwise>-\->
				<xsl:for-each select="//NM_MISC_INSTRUCT_PNCNCTBP/CHART_LIST/CHART">
					<tr>
						<td style="vertical-align:text-top;">
							<xsl:element name="b">
								<xsl:if test="normalize-space(translate(CHART_NUM,'NZ ',''))">
									<!-\-<xsl:value-of select="concat('NZ ',translate(CHART_NUM,'NZ ',''))"/>-\->
									
									<xsl:choose>
										<xsl:when test="..//CHART_INT_NUM">
											<!-\-<xsl:value-of select="concat('NZ ',translate(.,'NZ ',''),'(',..//CHART_INT_NUM,')',',')"/>-\->
											
											<!-\-<xsl:value-of select="concat('NZ ',translate(CHART_NUM,'NZ ',''),'(',..//CHART_INT_NUM,')')"/>-\->
											<xsl:value-of select="concat(CHART_NUM,'(',..//CHART_INT_NUM,')')"/>
										</xsl:when>
										<xsl:otherwise>
											<!-\-<xsl:value-of select="concat('NZ ',translate(CHART_NUM,'NZ ',''))"/>-\->
											<!-\-<xsl:value-of select="CHART_NUM"/>-\->
											<xsl:value-of select="concat(substring(CHART_NUM,1,2),' ',substring(CHART_NUM,3,15))"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:element>
						</td>
						<td style="vertical-align:text-top;">
							<xsl:element name="b">
								<xsl:value-of select="CHART_TITLE"/>
							</xsl:element>
						</td>
					</tr>
				</xsl:for-each>
			<!-\-</xsl:otherwise>
		</xsl:choose>-\->
	</xsl:template>-->
	<xsl:template name="charts-to-be-published">
		<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNCTBP)">
				<tr><td style="font:arial;font-size:9pt;">NIL</td></tr>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNCTBP//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]">
					<xsl:sort select="normalize-space(translate(CHTNUM,'NZ',''))" data-type="number" order="ascending"/>
			<tr>
				<td style="vertical-align:text-top;">
					<xsl:element name="b">
							<xsl:if test="normalize-space(translate(CHTNUM,'NZ ',''))">
								<xsl:value-of select="concat(substring(CHTNUM,1,2),' ',substring(CHTNUM,3,15))"/>
								<xsl:if test="normalize-space(INTNUM ) != '' ">
									<xsl:text> (</xsl:text>										
									<xsl:value-of select="normalize-space(INTNUM)"/>
									<xsl:text>)</xsl:text>
								</xsl:if>
							</xsl:if>
					</xsl:element>
				</td>
				<td style="vertical-align:text-top;">
					<xsl:element name="b">
						<xsl:value-of select="CTITL1"/>
					</xsl:element>
				</td>
			</tr>
		</xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template for editions to be published section -->
	<!--<xsl:template name="editions-to-be-published">
		<!-\-<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNETBP/CHART_LIST/CHART)">
				<tr><td style="font:arial;font-size:9pt;">NIL</td></tr>
			</xsl:when>
			<xsl:otherwise>-\->
		<xsl:for-each select="//NM_MISC_INSTRUCT_PNCNETBP/CHART_LIST/CHART">
			<tr>
				<td style="vertical-align:text-top;">
					<xsl:element name="b">
						<xsl:if test="normalize-space(translate(CHART_NUM,'NZ ',''))">
							<!-\-<xsl:value-of select="concat('NZ ',translate(CHART_NUM,'NZ ',''))"/>-\->
							<xsl:choose>
								<xsl:when test="..//CHART_INT_NUM">
									<!-\-<xsl:value-of select="concat('NZ ',translate(.,'NZ ',''),'(',..//CHART_INT_NUM,')',',')"/>-\->
									
									<!-\-<xsl:value-of select="concat('NZ ',translate(CHART_NUM,'NZ ',''))"/>-\->
									<xsl:value-of select="CHART_NUM"/>
									<br/>
									<xsl:value-of select="concat('(',..//CHART_INT_NUM,')')"/>
									
								</xsl:when>
								<xsl:otherwise>
									<!-\-<xsl:value-of select="concat('NZ ',translate(CHART_NUM,'NZ ',''))"/>-\->
<!-\-									<xsl:value-of select="CHART_NUM"/>-\->
									<xsl:value-of select="concat(substring(CHART_NUM,1,2),' ',substring(CHART_NUM,3,15))"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:element>
				</td>
				<td style="vertical-align:text-top;">
					<xsl:element name="b">
						<xsl:value-of select="CHART_TITLE"/>
					</xsl:element>
				</td>
			</tr>
		</xsl:for-each>
			<!-\-</xsl:otherwise>
		</xsl:choose>-\->
	</xsl:template>-->
	<xsl:template name="editions-to-be-published">
		<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_PNCNETBP)">
				<tr><td style="font:arial;font-size:9pt;">NIL</td></tr>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//AFFECTED_CHART_LIST/PPRCHT[CHART_SHEET_LIST/CHART_SHEET_LIST_ITEM/PPRSHT/SHEET_PANEL_LIST/SHEET_PANEL_LIST_ITEM/PPRPAN/@id = //NM_MISC_INSTRUCT_PNCNETBP//INSTRUCTION_PANEL_LIST/INSTRUCTION_PANEL_LIST_ITEM/PPRPAN/@id]">
					<xsl:sort select="normalize-space(translate(CHTNUM,'NZ',''))" data-type="number" order="ascending"/>
					<tr>
						<td style="vertical-align:text-top;">
							<xsl:element name="b">
								<xsl:if test="normalize-space(translate(CHTNUM,'NZ ',''))">
									<xsl:value-of select="concat(substring(CHTNUM,1,2),' ',substring(CHTNUM,3,15))"/>
									<xsl:if test="normalize-space(INTNUM ) != '' ">
										<xsl:text> (</xsl:text>										
										<xsl:value-of select="normalize-space(INTNUM)"/>
										<xsl:text>)</xsl:text>
									</xsl:if>
								</xsl:if>
							</xsl:element>
						</td>
						<td style="vertical-align:text-top;">
							<xsl:element name="b">
								<xsl:value-of select="CTITL1"/>
							</xsl:element>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- template for electronic navigation charts section -->
	<xsl:template name="electronic-navigational-charts">
		<!--<xsl:choose>
			<xsl:when test="not(//NM_MISC_INSTRUCT_ENC[ancestor::NM_ENC_PUB])">
				<tr><td style="font:arial;font-size:9pt;">NIL</td></tr>
			</xsl:when>
			<xsl:otherwise>-->
		<xsl:for-each select="//NM_MISC_INSTRUCT_ENC[ancestor::NM_ENC_PUB]">
			<tr>
				<td style="vertical-align:text-top;">
					<xsl:element name="b">
						<xsl:value-of select="ENC_NAME"/>
						<!--<xsl:value-of select="concat(substring(ENC_NAME,1,2),' ',substring(ENC_NAME,3,15))"/>-->
					</xsl:element>
				</td>
				<!--<td style="vertical-align:text-top;">
					<xsl:if test="normalize-space(translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))">
						<xsl:element name="b">
							
							<!-\-<xsl:value-of select="concat('NZ ',translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))"/>-\->
							<xsl:choose>
								<xsl:when test="..//CHART_INT_NUM">
									<!-\-<xsl:value-of select="concat('NZ ',translate(.,'NZ ',''),'(',..//CHART_INT_NUM,')',',')"/>-\->
									
									<!-\-<xsl:value-of select="concat('NZ ',translate(CHART_NUM,'NZ ',''),'(',..//CHART_INT_NUM,')')"/>-\->
									<xsl:value-of select="concat(CHART_NUM,'(',..//CHART_INT_NUM,')')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="CHART_NUM"/>
								</xsl:otherwise>
							</xsl:choose>							
						</xsl:element>
						<xsl:text>&#160;</xsl:text>
						<xsl:text>&#160;</xsl:text> 
						<xsl:text>&#160;</xsl:text> 
						<b><xsl:text>&#8722;</xsl:text></b>
						<xsl:text>&#160;</xsl:text> 
						
					</xsl:if>
				</td>-->
				<xsl:variable name="space">
					<xsl:text>&#160;</xsl:text>
				</xsl:variable>
				<td style="vertical-align:text-top;">
					<xsl:element name="b">
						<xsl:if test="normalize-space(REGION)">
							<xsl:value-of select="REGION"/>
						</xsl:if>
						<xsl:if test="normalize-space(SUB_REGION)">
							<xsl:text>&#160;</xsl:text> 
							<xsl:text>&#160;</xsl:text>
							<xsl:value-of select="concat(' - ',$space,$space,SUB_REGION)"/>
							
						</xsl:if>
						<xsl:if test="normalize-space(VICINITY)">
							<xsl:text>&#160;</xsl:text> 
							<xsl:text>&#160;</xsl:text>
							<xsl:value-of select="concat(' - ',$space,$space,VICINITY)"/>
							  
						</xsl:if>
					</xsl:element>
				</td>
				<td style="vertical-align:text-top;">
					<xsl:element name="i">
						<xsl:value-of select="NZ_CHART_PUB"/>
					</xsl:element>
				</td>
			</tr>
		</xsl:for-each>
			<!--</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>

	<xsl:template name="publications-to-be-cancelled">
		<xsl:choose>
			<xsl:when test="not(//NM_PUB_CAN_COMP[ancestor::NM_PUB_CAN])">
				<tr><td style="font:arial;font-size:9pt;">NIL</td></tr><br/>
			</xsl:when>
			<xsl:otherwise>
		<xsl:for-each select="//NM_PUB_CAN_COMP[ancestor::NM_PUB_CAN]">
			<xsl:variable name="edition">
				<xsl:if test="normalize-space(EDITION)">
					<xsl:value-of select="concat(' ',EDITION,' Edition')"/>
				</xsl:if>
			</xsl:variable>
			<tr>
				<td style="vertical-align:text-top;">
					<xsl:value-of select="NZ_ANN_PUB_NUM"/>
				</td>
				<td style="vertical-align:text-top;">
					<xsl:value-of select="concat(TITLE,$edition)"/>
				</td>
			</tr>
		</xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="nm_gen_seciii">
		
		<xsl:call-template name="section-header">
			<xsl:with-param name="section-number">
				<xsl:value-of select="'III'"/>
			</xsl:with-param>
		</xsl:call-template>
		<div id="section-three" align="justify">
			<br/><br/>
			<h5 style="text-align:center;font-size:10pt;">
				<a name ='section-three'><xsl:value-of select="'GENERAL NOTICES'"/></a>
			</h5>
			<br/><br/><br/>
			<b>ENC/ECDIS DATA PRESENTATION AND PERFORMANCE CHECK IN SHIPS</b><br/><br/>
			<div style="text-align: justify"><span style="text-align:justify;font:arial;font-size:9pt;margin-top:10px;margin-bottom:12px;">The International Maritime Organization
				(IMO) has recently indicated its concerns about operating anomalies identified in some ECDIS
				that fail to display important new chart features.</span></div><br/>
			<div style="text-align: justify"><span style="text-align:justify;font:arial;font-size:9pt;margin-bottom:12px;margin-top:0px;">The International Hydrographic
				Organization (IHO) has produced an ENC Data Presentation and Performance Check dataset that
				allows mariners to check their ECDIS. The check dataset is available through ENC service
				providers and from the IHO website (<a href="http://www.iho.int/">www.iho.int</a>) which
				includes instructions.</span></div><br/>
			<div style="text-align: justify"><span style="text-align:justify;font:arial;font-size:9pt;margin-bottom:12px;margin-top:0px;">Mariners are strongly recommended to use
				the dataset and report the results of their checks to help the IHO identify how the
				different brands of ECDIS display and handle chart information. Mariners are asked to also
				inform the IMO, national Hydrographic Offices, ECDIS manufacturers and others, so that they
				can take any corrective action that may be necessary.</span></div><br/>
			<div style="text-align: justify"><span style="text-align:justify;font:arial;font-size:9pt;margin-bottom:12px;margin-top:0px;">In order to present the most
				comprehensive report possible to the IMO and to further assist in resolving the issues so
				far identified, the IHO is keen that as many ships as possible forward their results.
				Reports on the results can be sent via a form provided with the data or the results can be
				submitted on-line through a web-form.</span></div><br/>
			<div style="text-align: justify"><span style="text-align:justify;font:arial;font-size:9pt;margin-bottom:12px;margin-top:0px;">All relevant documentation can be
				downloaded free from the IHO website at: <a href="http://www.iho.int/">www.iho.int</a>.</span></div>
			<br/><br/><br/>
			
			<b>SOUTH PACIFIC OCEAN. MARITIME SAFETY BROADCASTS – OPTIMUM R/T FREQUENCIES WITHIN NAVAREA XIV</b><br/><br/>			
			<div style="text-align: left"><span style="text-align:left;font:arial;font-size:9pt;margin-bottom:12px;margin-top:0px;">Diagrams showing the optimum R/T calling and working frequency bands and times for navigational 
				warnings broadcast within 1000 nautical miles of Taupo Maritime Radio (ZLM) (38° 50’S., 176° 00’E. approx.)
				are available as follows: <br/> <a href="ftp://ftp.ips.gov.au/data/HF%20Systems/Monthly%20Predictions/9038/HAP9038Taupo_page_1.pdf">Hourly Area Predictions (HAP)</a>.</span>
				<div style="text-align: justify">	
					<span style="text-align:justify;font:arial;font-size:9pt;margin-bottom:12px;margin-top:0px;"><a href="ftp://ftp.ips.gov.au/data/HF%20Systems/Monthly%20Predictions/9038/LAMP9038NAVAREAXIV1.pdf">Local Area Mobile Predictions (LAMP)</a>.</span>
				</div><br/>
				<div style="text-align: justify">	
					<span style="text-align:justify;font:arial;font-size:9pt;margin-bottom:12px;margin-top:0px;">Australian Government IPS Radio and Space Services</span>
				</div>
				<div style="text-align: justify">	
					<span style="text-align:justify;font:arial;font-size:9pt;margin-bottom:12px;margin-top:0px;">HITS -/1</span>
				</div>	
			</div><br/>
		</div>
		
		<xsl:apply-templates select="//NM_CONTENT_COMP[parent::NM_GEN_SECIII]"/>
		
		<xsl:apply-templates select="//ATTACHMENT_LIST[parent::NM_GEN_SECIII]" mode="sect-v"/>
	</xsl:template>
	
	<xsl:template match="NM_CONTENT_COMP" name="nm_content_comp">
		<xsl:if test="TITLE !=''">
		<div>
			<p style="font-weight:bold;text-align:left;"><xsl:value-of select="TITLE"/></p>
			<xsl:copy-of select="NM_CONTENT"/>
		</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="NM_CAT_SECTION">
		
		<xsl:call-template name="section-header">
			<xsl:with-param name="section-number">
				<xsl:value-of select="'V'"/>
			</xsl:with-param>
		</xsl:call-template>
		<div id="section-five">
			<br/><br/>
			<p style="text-align:center; font-size:10pt;font-weight:bold;">
				<a name="section-five"><xsl:value-of select="'CORRECTIONS TO NEW ZEALAND PUBLICATIONS'"/></a>
			</p>
			
			<xsl:choose>
				<xsl:when test="not(SECTION_CONTENT_LIST/SECTION_CONTENT_LIST_ITEM/NM_CHART_CAT)">
					<!--<p style="text-align:center;">
						<xsl:value-of select="'Nil'"/>
					</p>-->
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="SECTION_CONTENT_LIST/SECTION_CONTENT_LIST_ITEM/NM_CHART_CAT != ''">
					<xsl:apply-templates select="SECTION_CONTENT_LIST/SECTION_CONTENT_LIST_ITEM/NM_CHART_CAT"/>
				</xsl:when>
			</xsl:choose>
			
		</div>
	</xsl:template>
	
	

	<xsl:template match="NM_CHART_CAT">
		<xsl:variable name="chart_edition">
			<xsl:choose>
				<xsl:when test="number(NZ_CHART_CAT_EDN) = NZ_CHART_CAT_EDN">
                    <xsl:value-of select="NZ_CHART_CAT_EDN"/>
                    <xsl:element name="sup">
                    <xsl:choose>
						<xsl:when test="NZ_CHART_CAT_EDN = '1' or NZ_CHART_CAT_EDN = '21' or NZ_CHART_CAT_EDN = '31' or NZ_CHART_CAT_EDN = '41' ">
                            <xsl:text>st</xsl:text>
                        </xsl:when>
						<xsl:when test="NZ_CHART_CAT_EDN = '2' or NZ_CHART_CAT_EDN = '22' or NZ_CHART_CAT_EDN = '32' or NZ_CHART_CAT_EDN = '42' ">
                            <xsl:text>nd</xsl:text>
                        </xsl:when>
						<xsl:when test="NZ_CHART_CAT_EDN = '3' or NZ_CHART_CAT_EDN = '23' or NZ_CHART_CAT_EDN = '33' or NZ_CHART_CAT_EDN = '43' ">
                            <xsl:text>rd</xsl:text>
                        </xsl:when>
						<xsl:otherwise>
                            <xsl:text>th</xsl:text>
                        </xsl:otherwise>
					</xsl:choose>
                    </xsl:element>
                </xsl:when>
				<xsl:otherwise><xsl:text>XX</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Section heading -->
		<p style="text-align:center; font-size:10pt;font-weight:bold;">
            <xsl:text>New Zealand Chart Catalogue </xsl:text>
			<xsl:copy-of select="$chart_edition"/>
            <xsl:text> Edition, NZ 202</xsl:text>
		</p>
		
		<xsl:choose>
			<xsl:when test="not(//NM_CAT_SEC_CONT)">
				<!--<p style="text-align:center;">
					<xsl:value-of select="'Nil'"/>
				</p>
				<br/><br/>-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="//NM_CAT_SEC_CONT"/>
				<br/><br/>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

	<xsl:template match="NM_CAT_SEC_CONT">
		<table style="width:630px;">
			<tbody style="padding:0;margin:0;">
				<tr style="margin-bottom:10px;margin-top:10px;">
					<td style="vertical-align:text-top;width:50px;">
						<xsl:if test="normalize-space(NZ_CAT_PAGE_NUM)">
							Page <xsl:value-of select="NZ_CAT_PAGE_NUM"/>
						</xsl:if>
					</td>
					<td style="vertical-align:text-top;width:80px;" colspan="5">
						<b><xsl:value-of select="translate(NZ_FOLIO_REGION,$small-case,$upper-case)"/></b>
					</td>
				</tr>
				<xsl:call-template name="chart-catalogue"/>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="NM_CAT_ANTOM">
		<xsl:variable name="cat_nm_year">
			<xsl:if test="not(NM_YEAR_PUB)">
				<xsl:value-of select="'XXXX/XX'"/>
			</xsl:if>
		</xsl:variable>
		
		<xsl:if test="(count(//NM_CAT_ANTOM)) >= 1">
			<xsl:if test="position() = 1">
				<h6 style="text-align:center;font:arial;font-size:10pt;font-weight:bold;">
					<xsl:value-of select="concat('New Zealand Nautical Almanac ',NM_YEAR_PUB,$cat_nm_year,', NZ 204')"/>
				</h6>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="count(//NM_CAT_ANTOM) != ''">
			<xsl:if test="position()">
				<xsl:if test="//NM_CAT_ANTOM != ''">
					<xsl:if test="NAME != '' and SECTION_NUMBER != '' and SUBJECT != '' and PAGE != ''">
						<table style="width:690px;">
							<tbody style="width:100%;">
								<tr style="line-height:30px;">
									<td style="vertical-align:text-top;width:80px;">
										<xsl:if test="normalize-space(PAGE)">
											Page <xsl:value-of select="PAGE"/>
										</xsl:if></td>
									<td style="vertical-align:text-top;width:500px;" colspan="5">
										<b><xsl:value-of select="concat(NAME,',', SECTION_NUMBER,' ',SUBJECT)"/></b>
									</td>
								</tr>
								<xsl:apply-templates select="NM_CONTENT" mode="sect-v"/>
							</tbody>
						</table>
					</xsl:if>
					<xsl:apply-templates select="ATTACHMENT_LIST" mode="sect-v"/>
					<xsl:apply-templates select="SECTION_CONTENT_LIST/SECTION_CONTENT_LIST_ITEM/NM_CAT_SUB_ANTOM"/>
					<br/><br/>
					<xsl:if test="(//NM_CAT_ANTOM != '' and not(//NM_CAT_SUB_ANTOM))">
						<xsl:choose>
							<xsl:when test="count(//NM_CAT_ANTOM) = 1 and not(P) and not(//NM_CAT_SUB_ANTOM)">
								<!--<p style="text-align:center;">
									<xsl:value-of select="'Nil'"/>
								</p>
								<br/>-->
							</xsl:when>
						</xsl:choose>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="//NM_CAT_ANTOM = ''">
				<xsl:choose>
					<xsl:when test="not(NAME) and not(SECTION_NUMBER) and not(SUBJECT) and not(PAGE)">
						<xsl:if test="not(ATTACHMENT_LIST) and not(ATTACHMENT) and not(FILENAME) and not(NM_IMG_TYPE)">
							<xsl:if test="(count(//NM_CAT_SUB_ANTOM)) != 1">
								<xsl:if test="not(NAME) and not(ACTION) and not(NM_PORT) and not(CALLSIGN) and not(NM_FREQUENCY)">
									<p style="text-align:center;">
										<xsl:value-of select="'Nil'"/>
									</p>
									<br/><br/>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
			
		</xsl:if>
		
	</xsl:template>

	<xsl:template match="NM_CONTENT" mode="sect-v">
		<xsl:if test="normalize-space(.)">
			<tr>
				<td colspan="6">
				<xsl:value-of select="."/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="NM_CAT_SUB_ANTOM">
		<table style="width:690px;">
			<tbody>
				<tr>
					<td style="vertical-align:text-top;width:80px;">
						<i><xsl:apply-templates select="ACTION"/></i>		
					</td>
					<td style="vertical-align:text-top;width:100px;">
						<xsl:apply-templates select="NM_PORT"/>		
					</td>
					<td style="vertical-align:text-top;width:100px;">
						<xsl:apply-templates select="CALLSIGN"/>		
					</td>
					<td style="vertical-align:text-top;width:50px;">
						<xsl:apply-templates select="NM_FREQUENCY"/>		
					</td>
					<td style="vertical-align:text-top;width:50px;"/>
				</tr>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="nm_gen_secvi">
		
		<xsl:call-template name="section-header">
			<xsl:with-param name="section-number">
				<xsl:value-of select="'VI'"/>
			</xsl:with-param>
		</xsl:call-template>
		<div>
			<br/>
			<h5 align="center" style="font-size:10pt;">
				<a name="section-six">
					<b>CORRECTIONS TO ADMIRALTY PUBLICATIONS</b></a></h5>
			<br/><br/><br/>
			<p style="text-align:left;font:arial;font-size:9pt;margin-bottom:2px;">The New Zealand Hydrographic Authority
				no longer publishes corrections to Admiralty Publications as part of the fortnightly New
				Zealand Notice to Mariners Edition. For information regarding these publications please
				refer to: <a href="https://www.admiralty.co.uk/publications"
					>https://www.admiralty.co.uk/publications</a>.</p>
		</div><br/>
		<!--<hr/>-->
		<xsl:if test="/NTC_PUBLICATION/SECTION_LIST/SECTION_LIST_ITEM/NM_GEN_SECVI/NAME !=''">
			
			<!--Venkat Updated 19-Sep-2018-->
		<!--<div>
			<br/><br/>
			<h5 align="center" style="font-size:10pt;"><b><xsl:value-of select="/NTC_PUBLICATION/SECTION_LIST/SECTION_LIST_ITEM/NM_GEN_SECVI/NAME"/></b></h5>
			<br/><br/><br/>
			<xsl:apply-templates select="/NTC_PUBLICATION/SECTION_LIST/SECTION_LIST_ITEM/NM_GEN_SECVI/NM_CONTENT"/>
		</div>-->
		<hr/><br/>
		</xsl:if>
		
	</xsl:template>

	<xsl:template name="nm_gen_secvii">
		<br/>
		<div>
			<h5 align="center" style="font-size:10pt;"><b><xsl:value-of select="'VII'"/></b></h5>
			<br/><br/>
			<h5 align="center" style="font-size:10pt;">
				<a name="section-seven"><b>NAVIGATIONAL WARNINGS</b></a>
			</h5>
			<br/><br/><br/>
			<p style="text-align:left;font:arial;font-size:9pt;">The New Zealand Hydrographic Authority
				no longer publishes navigational warnings for NAVAREA XIV and NZ Coastal Area Z as part of
				the fortnightly New Zealand Notice to Mariners Edition. </p>
			<p style="text-align:left;font:arial;font-size:9pt;">New Zealand navigational warnings are
				available at: <a
					href="https://www.maritimenz.govt.nz/commercial/safety/maritime-radio/navigational-warnings.asp"
					>https://www.maritimenz.govt.nz/commercial/safety/maritime-radio/navigational-warnings.asp</a>. </p>
			<p style="text-align:left;font:arial;font-size:9pt;">Australian navigational warnings are
				available at: <a
					href="https://www.amsa.gov.au/safety-navigation/navigation-systems/maritime-safety-information-database"
					>https://www.amsa.gov.au/safety-navigation/navigation-systems/maritime-safety-information-database</a>. </p>
			<p style="text-align:left;font:arial;font-size:9pt;">As these lists may not be up to date it
				is not an authoritative source of navigational warnings so Masters/Captains are still
				required to receive navigational warnings from the appropriate International Maritime
				Organization (IMO) or World Meteorological Organization (WMO) approved Global Maritime
				Distress and Safety System (GMDSS) broadcast service i.e. the International SafetyNET
				system. </p>
			
		</div><br/><br/>
		<hr/>
		<!--<xsl:apply-templates select="//NM_GEN_SECVII"/>-->
	</xsl:template>
	
	<!--Venkat Updated 19-Sep-2018-->
	<!--<xsl:template match="NM_GEN_SECVII">
		<xsl:if test="SECTION_NUMBER !=''">
		<br/><br/><br/><br/>
		<div>
			<h5 align="center" style="font-size:12pt;"><b><xsl:value-of select="SECTION_NUMBER"/></b></h5>
			<br/>
			<h5 align="center" style="font-size:10pt;"><b><xsl:value-of select="NAME"/></b></h5>
			<br/><br/><br/>
			<!-\-<span><xsl:apply-templates select="NM_NAV_LABEL/NM_CONTENT"/></span><br/><br/>-\->
			<xsl:for-each select="NM_NAV_LABEL/NM_CONTENT">
				<div><span><xsl:value-of select="."/></span></div><br/>
			</xsl:for-each><br/><br/><br/>
			<xsl:if test="NM_CONTENT_COMP/TITLE !=''">
				<xsl:variable name="title">
					<xsl:value-of select="NM_CONTENT_COMP/TITLE"/>
				</xsl:variable>
				<b><xsl:value-of select="$title"/></b>
			</xsl:if>
			<br/><br/>
			<span><xsl:apply-templates select="NM_CONTENT_COMP/NM_CONTENT"/></span><br/><br/><br/>
			<br/>
			
			
		</div>
		<!-\-<hr/>-\->
		</xsl:if>
	</xsl:template>-->
	<xsl:template name="chart-catalogue">
		<xsl:variable name="action" select="ACTION"/>
		<xsl:for-each select="INSTRUCTION_LIST/INSTRUCTION_LIST_ITEM/NM_CAT_INSTRUCTIONS">
			<tr>
				<td style="vertical-align:text-top;width:80px;">
					<xsl:if test="position() = 1"><i>
					<xsl:choose>
						<xsl:when test="$action = 'Modify'">
							<xsl:text>Amend</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$action"/>
						</xsl:otherwise>
					</xsl:choose></i>
					</xsl:if>
				</td>
				<td style="vertical-align:text-top;width:60px;">
					<xsl:if test="normalize-space(translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))">
						<!--<xsl:value-of select="concat('NZ ',translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))"/>-->
						
						<!--<xsl:value-of select="concat('NZ ',translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))"/>-->
						<xsl:choose>
							<xsl:when test="..//CHART_INT_NUM">
								<!--<xsl:value-of select="concat('NZ ',translate(.,'NZ ',''),'(',..//CHART_INT_NUM,')',',')"/>-->
								
								<!--<xsl:value-of select="concat('NZ ',translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))"/>-->
								<xsl:value-of select="CHART_LIST/CHART/CHART_NUM"/>
								<br/>
								<xsl:value-of select="concat('(',..//CHART_INT_NUM,')')"/>
							</xsl:when>
							<xsl:otherwise>
								<!--<xsl:value-of select="concat('NZ ',translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))"/>-->
								<xsl:value-of select="CHART_LIST/CHART/CHART_NUM"/>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:if>
				</td>

				<td colspan="2" style="vertical-align:text-top;width:300px;">
					<xsl:apply-templates select="CHART_LIST/CHART" mode="nz202-chart"/>
				</td>
				
				<td style="vertical-align:text-top;width:50px;text-align:right;">
					<xsl:value-of select="NZ_CHART_PUB"/>
				</td>
				<td style="vertical-align:text-top;width:50px;text-align:right;">
					<!-- If we've multiple charts then also we'll have edition date info in the first chart itself-->
					<xsl:value-of select="NM_EDITION"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="CHART" mode="nz202-chart">
		<table style="width:100%;padding:0;margin:0;border-collapse:collapse;">
				<xsl:if test="not(preceding-sibling::CHART)">
					<tr>
						<xsl:choose>
							<xsl:when test="count(../CHART) = 1">
								<td style="vertical-align:text-top;width:75%;margin-top:0px;margin-bottom:0px" colspan="1">
									<xsl:apply-templates select="CHART_TITLE"/>
								</td>
								<td style="vertical-align:text-top; width:18.8%;text-align:right;">
									<xsl:value-of select="translate(PANEL/CHART_SCALE, ',', ' ')"/>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td style="vertical-align:text-top;width:69%;margin-top:0px;margin-bottom:0px" colspan="2">
									<xsl:apply-templates select="CHART_TITLE"/>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</xsl:if>
			<xsl:variable name="extra-rows">
				<tr><td style="margin-left:.5in">
					<xsl:choose>
						<xsl:when test="PANEL">
							<xsl:if test="not(count(../CHART)=1)">
								<xsl:apply-templates select="PANEL/PANEL_NAME"/><br/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise><br/></xsl:otherwise>
					</xsl:choose>
				</td>
					<xsl:if test="not(count(../CHART)=1)">
						<td style="vertical-align:text-top; width:18.8%;text-align:right;">
							<xsl:value-of select="translate(PANEL/CHART_SCALE, ',', ' ')"/>
						</td>
					</xsl:if>
				</tr>
			</xsl:variable>
			<xsl:if test="normalize-space($extra-rows)">
				<xsl:copy-of select="$extra-rows"/>
			</xsl:if>
		</table>
	</xsl:template>
	
	<xsl:template mode="html" match="CHART_TITLE | CHART_SCALE">
		<xsl:value-of select="."/>
		<xsl:element name="br"/>
	</xsl:template>

	<xsl:template match="COLUMN">
		<xsl:apply-templates/>
		<xsl:element name="br"/>
	</xsl:template>

	<xsl:template name="generate-hydrographic-note">
		<br/>
		<span><br style="mso-special-character:line-break; page-break-before:always"/></span>
		<div style="width:100%;">
			<table style="width:100%;">
				<tr>
					<td style="text-align:right"><img width="250" height="65">
						<xsl:attribute name="src">
							<xsl:value-of select="'N:\HPD\shared\HPD310\PM_LINZConfiguration\R5\Instructions_Stylesheets\HN_Header.jpg'"/>
						</xsl:attribute>
					</img></td>
				</tr>
			</table>
		</div>
		<div>
			<p style="text-align:center;font-size:12pt;">
				<b><a style="color:black;text-decoration:none;" href="https://www.linz.govt.nz/sea/maritime-safety-information/reporting-hazard-navigation-h-note">HYDROGRAPHIC NOTE</a></b>
			</p>
			<p style="text-align:center;font-size:10pt;">
				<b>(For instructions, see next page)</b>
			</p>
			<p style="font-size:10pt;">New Zealand Hydrographic Authority<br/>
			Land Information New Zealand<br/>
			Radio New Zealand House<br/>
			155 The Terrace<br/>
			PO Box 5501<br/>
			Wellington 6145<br/>
			New Zealand</p>
			
			<p style="line-height:95%;font-size:10pt;">Tel: 0800 665 463 or +64 (0)4 460 0110<br/>
			Email: <A href="mailto:ntm@linz.govt.nz">ntm@linz.govt.nz</A></p>
			<table style="font:arial;font-size:10pt;">
				<tbody>
					<tr style="line-height:25px;">
						<td>Date
							................................................................................</td>
						<td>Ref. No.
							....................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td colspan="2">Name and address of ship or sender </td>
					</tr>
					<tr style="line-height:25px;">
						<td>
							.........................................................................................</td>
						<td>...................................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>
							.........................................................................................</td>
						<td>
							...................................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>Tel/Email of sender
							........................................</td>
						<td>...................................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>General locality
							...............................................................</td>
						<td>...................................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>Subject
							...........................................................................</td>
						<td>...................................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>Position. Lat.
							...................................................................</td>
						<td>Long.
							........................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>Position fixing system used
							............................................</td>
						<td>...................................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>Datum
							.............................................................................</td>
						<td>...................................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>Paper Chart/ENC affected
							.............................................</td>
						<td>Edition
							......................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td colspan="2">Dated
							...............................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td>Latest Notice to Mariners held
							........................................</td>
						<td>...................................................................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td colspan="2">Publications affected (Edition No. and date of latest
							supplement, page no., ID no.
							etc).....................................</td>
					</tr>
					<tr style="line-height:25px;">
						<td colspan="2">Details:</td>
					</tr>
					<tr>
						<td colspan="2">
							<br/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<br/>
							<br/>
							<br/>
						</td>
					</tr>
					<tr>
						<td>A replacement copy of Chart No.
							...................................</td>
						<td>...................................................................................</td>
					</tr>
					<tr style="line-height:200%;">
						<td colspan="2">is required (see Instruction 4). </td>
					</tr>
					<tr>
						<td>Signature of observer/reporter
							.......................................</td>
						<td>...................................................................................</td>
					</tr>
				</tbody>
			</table>
		</div>
		<span><br style="mso-special-character:line-break; page-break-before:always"/></span>
		<div>
			<p style="text-align:center;font-size:24pt;">
				<b>HYDROGRAPHIC NOTE</b>
			</p>
			<p style="text-align:center;">
				<b>Forwarding Information for Charts and Hydrographic Publications</b>
			</p>
			<table style="margin-top:6px;margin-bottom:6px;background-color:silver;border-top:1px solid black;border-bottom:1px solid black;">
					<tr>
						<td><p style="text-align:justify;">
					<b>Note:</b> An acknowledgement of receipt will be
					sent and the information then used to the best advantage, which may mean<br/>
					immediate action or inclusion in a revision in due course. When a Notices to
					Mariners is issued, the sender’s ship or name is<br/> quoted as authority unless
					(as sometimes happens) the information is also received in a foreign Notices to
					Mariners. An<br/> explanation of the use of contributions from all parts of the
					world would be too greater task and a further communication<br/> should only be
					expected when the information is of outstanding value or has unusual
					features.</p></td>
					</tr>
				</table>
			
			<p><b>INSTRUCTIONS:</b></p>
			<ol>
				<li style="text-align:justify;margin-bottom:8px;">Mariners are requested to notify New Zealand
					Hydrographic Authority, Land Information New Zealand, 155 The Terrace, PO Box
					5501, Wellington 6145, New Zealand, when new or suspected dangers to navigation
					are discovered, changes observed in aids to navigation, or corrections to
					publications seem to be necessary. The <i>Admiralty</i> publication, <i>The Mariner’s
						Handbook</i> (NP100), Chapter 4, gives general instructions.</li>
				
				<!--Venkat Updated 19-Sep-2018-->
				<li style="text-align:justify;margin-bottom:8px;">This form and its instructions have been designed to
					help both the sender and the recipient. It should be used, or followed, closely,
					whenever appropriate. Copies of this form may be obtained gratis from the New
					Zealand Hydrographic Authority at the address above, or in PDF format directly
					from the LINZ website, <a href="https://www.linz.govt.nz/sea">www.linz.govt.nz/sea</a>.
					<br/></li>
				<li style="text-align:justify;margin-bottom:8px;">When a position is defined by sextant angles or
					bearings (true or magnetic being specified) more than two should be used in
					order to provide a check. Distances observed by radar should be quoted. However,
					when there is a series of fixes along a ship’s course, only the method of fixing
					and the objects used need to be indicated. Latitude and longitude should only be
					used specifically to position the details when they have been fixed by
					astronomical observations or GPS and a full description of the method, equipment
					and datum used should be given.<br/></li>
				<li style="text-align:justify;margin-bottom:8px;">Paper Charts: A cutting from the largest scale paper
					chart is the best medium for forwarding details, the alterations and additions
					being shown thereon in red. When requested, a new copy will be sent in
					replacement of a chart that has been used to forward information, or when
					extensive observations have involved defacement of the observer’s chart. If it
					is preferred to show the amendments on a tracing of the largest scale chart
					(rather than the chart itself) these should be in red as above, but adequate
					detail from the chart must be traced in black ink to enable the amendments to be
					fitted correctly. 
					<p style="padding-left:5px;margin-bottom:0px;margin-top:0px;">Electronic Navigational Charts (ENCs): A screen dump of
					the largest scale usage band ENC with the alterations and additions being shown
					thereon in red.</p></li>
				<li style="text-align:justify;margin-bottom:8px;margin-top:8px;">When soundings are obtained, <i>The Mariners Handbook</i>
					(NP100) should be consulted. The echo sounding trace should be marked with
					times, depths, etc., and forwarded with the report. It is important to state
					whether the echo sounder is set to register depths below the surface, or below
					the keel; in the latter case the vessel’s draught should be given. Time and date
					should be given in order that corrections for the height of the tide may be made
					where necessary. The make, name, and type of echo sounder set should also be
					given.<br/></li>
				<li style="text-align:justify;margin-bottom:8px;">Modern echo sounders frequently record greater
					depths than the set’s nominal range, e.g. with a set whose maximum is 500m a
					trace appearing at 50m may in fact be 550m or even 1,050m. Erroneous deep
					soundings beyond the sets nominal range can usually be recognised by the
					following: 
					<p style="padding-left:5px;margin-bottom:8px;margin-top:8px;">(a) The trace being weaker than
						normal for the depth registered</p>
					<p style="padding-left:5px;margin-bottom:8px;margin-top:2px;">(b) The trace appearing to pass
						through the transmission line</p>
					<p style="padding-left:5px;margin-top:2px;margin-bottom:0px;">(c) The “feathery” nature of the
						trace.</p>
				</li>
				<li style="text-align:justify;margin-bottom:8px;margin-top:8px;">Reports which cannot be confirmed or are lacking in
					certain details should not be withheld. Shortcomings should be stressed and any
					firm expectation of being able to check the information on a succeeding voyage
					should be mentioned.<br/></li>
				<li style="text-align:justify;margin-bottom:8px;">Reports of shoal soundings, uncharted dangers and
					navigational aids out of order should, at the mariner’s discretion, also be made
					by radio to the nearest coast radio station. The draught of modern tankers is
					such that any uncharted depth under 30 metres or 15 fathoms may be of sufficient
					importance to justify a radio message.<br/></li>
			</ol>
		</div>
		<br style="page-break-before:always"/>
		<br/>
	</xsl:template>

	<!--this is the common template to print paragraphs under different sections -->
	<xsl:template name="print-para">
		<div style="text-align:justify;">
		<p style="font:arial:font-size:9pt;margin-bottom:7px;">
			<xsl:if test="PARAGRAPH_PREFIX !=''">
								<b>
									<xsl:value-of select="normalize-space(PARAGRAPH_PREFIX)"/>
								</b>
			</xsl:if>
								<xsl:if test="ancestor::NM_ENC_PUB">
									<br/>
								</xsl:if>
								<xsl:text> </xsl:text>
			<xsl:if test="PARAGRAPH_ENG[1] !=''">
								<xsl:apply-templates select="PARAGRAPH_ENG[1]"/>
						</xsl:if>
							</p></div>
							<xsl:for-each select="PARAGRAPH_ENG[position()!=1]">
								<p style="font:arial:font-size:9pt;margin-top:0px;margin-bottom:0px;"><xsl:value-of select="."/></p>
							</xsl:for-each>
						
	</xsl:template>

	<!-- A template for generic sections node -->
	<xsl:template match="SECTION_LIST">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- A template for generic section contents node -->
	<xsl:template match="SECTION_CONTENT_LIST">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- A template for generic section contents node -->
	<xsl:template match="SECTION_CONTENT_LIST_ITEM">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Template for each Light List Record -->
	<xsl:template match="NM_LIGHT_LIST_RECORD">
			<table style="width:100%;font-size:8pt;">
		<tr style="vertical-align:text-top;">
			<td style="width:10%;font-weight:bold;"><xsl:value-of select="INTERNATIONAL_NUMBER"/></td>
			<td style="width:20%;"><xsl:copy-of select="LOC_NAME_CHART_NUM_ENG/node()"/></td>
			<td style="width:14%;text-align:right;">
				<xsl:value-of select="translate(POSITION/LATITUDE,'NEWS','')"/>
				<br/>
				<xsl:value-of select="translate(POSITION/LONGITUDE,'NEWS','')"/>
			</td>
			<td style="width:14%;padding-left:15px;"><xsl:value-of select="LIGHT_CHARACTERISTICS_ENG"/></td>
			<td style="width:5%;"><xsl:value-of select="LIGHT_HEIGHT"/></td>
			<td style="width:5%;"><xsl:copy-of select="LUM_GEO_RANGE/node()"/></td>
			<td style="width:20%;"><xsl:copy-of select="DESC_STRUCT_HEIGHT_ENG/node()"/>
				
				<xsl:variable name="height" select="STRUCT_HEIGHT"/>
				<xsl:if test="$height != ''"><p style="text-align:center;margin-top: 0px;margin-bottom: 2px;"><xsl:value-of select="$height"/></p></xsl:if>
			</td>
			<td style="width:20%;"><!--<p style="margin-left: 15px"><xsl:copy-of select="NM_REMARKS"/></p>-->
				<!--<xsl:value-of select="count(i)"/>-->
				
				<!--<p style="margin-left: 15px"><xsl:copy-of select="OBSERVATION_ENG"></xsl:copy-of></p>-->
				<!--<xsl:copy-of select="OBSERVATION_ENG"></xsl:copy-of>
				<xsl:choose>
					<xsl:when test="NM_LIGHTS_STATUS='Temporary'">
						<!-\-<xsl:text> (T) </xsl:text>-\->
						<br/><strong> T </strong>
					</xsl:when>
					<xsl:when test="NM_LIGHTS_STATUS='Racon temporarily discontinued'">
						<!-\-<xsl:text> (TR) </xsl:text>-\->
						<br/><strong> TR </strong>
					</xsl:when>
					<xsl:when test="NM_LIGHTS_STATUS='Preliminary'">
						<!-\-<xsl:text> (P) </xsl:text>-\->
						<br/><strong> P </strong>
					</xsl:when>
					<xsl:when test="NM_LIGHTS_STATUS='Temporarily discontinued (non-light AtoN)'">
						<!-\-<xsl:text> (TD) </xsl:text>-\->
						<br/><strong> TD </strong>
					</xsl:when>
					<xsl:when test="NM_LIGHTS_STATUS='Temporarily extinguished (light AtoN)'">
					<!-\-	<xsl:text> (TE) </xsl:text>-\->
						<br/><strong> TE </strong>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
				<xsl:if test="NM_LIGHTS_STATUS != ''">
					<strong><xsl:value-of select="../../../NM_YEAR_PUB"/></strong>	
				</xsl:if>-->
			</td>
		</tr>
		</table>
		
	</xsl:template>

	<!-- A template for the each Chart Notice-->
	
	
	
	
	
	<xsl:template match="NM_CHART_SECTION" name="nm_chart_section">
		<!-- Make a division/section for the Permanent Chart Notices -->
		<xsl:call-template name="section-header">
			<xsl:with-param name="section-number">
				<xsl:value-of select="'IV'"/>
			</xsl:with-param>
		</xsl:call-template>
		<div>
			<br/>
			<br/>
			<h5 style="text-align:center;font-size:10pt;">
				<a name="section-four"><xsl:value-of select="'NOTICES TO MARINERS'"/></a>
			</h5>
			<br/>
			<br/>
			<br/>
			<h6 style="text-align:center;font-size:10pt;"><b><xsl:value-of select="'Index of Charts Affected'"/></b></h6>
			<br/>
			<br/>
			<br/>

			<!-- This is to print the chart-notices affected summary table -->
			<xsl:variable name="result">
				<xsl:for-each select="//NM_TORP_NTC[not(ancestor::CANCELLED_NOTICE_LIST)] | //NM_CHART_NTC">
					<xsl:variable name="term">
						<xsl:choose>
							<xsl:when test="not(TERM)"/>
							<xsl:when test="normalize-space(TERM)">
								<xsl:value-of select="concat('(',substring(TERM,1,1),')')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="notice-num">
						<xsl:choose>
							<xsl:when test="contains(PUBLISH_NUMBER,'NZ')">
								<xsl:value-of select="normalize-space(substring-after(concat(substring-before(PUBLISH_NUMBER,'/'),$term),'NZ'))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat(substring-before(PUBLISH_NUMBER,'/'),$term)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable> 
						
					<xsl:variable name="chart-string">
						<xsl:choose>
							<xsl:when test="local-name(.)='NM_TORP_NTC'">
								<xsl:value-of select="normalize-space(NM_CHART_AFFECTED_LIST/CHART_NUM)"/>
							</xsl:when>
							<xsl:when test="local-name(.)='NM_CHART_NTC'">
								<xsl:variable name="delimit-values">
									<xsl:for-each select=".//CHART_NUM[normalize-space()]">
										<xsl:sort select="." order="ascending" data-type="number"/>
										<xsl:value-of select="."/>
										<xsl:choose>
											<xsl:when test="../../../CHART_LIST/CHART/CHART_INT_NUM[normalize-space()] != ''">
												<xsl:text> (</xsl:text>										
												<xsl:value-of select="(../../../CHART_LIST/CHART/CHART_INT_NUM[normalize-space()])"/>
												<xsl:text>),</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>,</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:variable>
								<xsl:call-template name="distinct-charts">
									<xsl:with-param name="delimit-charts" select="$delimit-values"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>	
					<xsl:variable name="modified_chart_string">
						<xsl:choose>
							<xsl:when test="contains($chart-string,'NZ')">
								<xsl:value-of select="concat('NZ ',normalize-space(substring-after($chart-string,'NZ')))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('NZ ',$chart-string)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!--<xsl:text> modified_chart_string </xsl:text>
					<xsl:value-of select="$modified_chart_string"/>
					<xsl:text> *** </xsl:text>
					<xsl:text> $notice-num </xsl:text>
					<xsl:value-of select="$notice-num"/>
					<xsl:text> *** </xsl:text>-->
					<xsl:call-template name="split">						
						<xsl:with-param name="string" select="$modified_chart_string"/>
						<xsl:with-param name="notice" select="$notice-num"/>
						
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>
			
<!--			<div style="padding-left:50px;">
				<table style="margin-left:1.65in;mso-padding-left-alt:5.0pt;align:center;padding:0px;">
					<tr>
						<td style="height:30px;vertical-align:text-center;text-align:center;border-top:3px solid black;width:150px;border-bottom: 1px solid black;border-right: 1px solid;line-height:120%;"><p style="margin-top:10px;margin-bottom:5px;">Chart No.</p></td>
						<td style="height:30px;vertical-align:text-center;text-align:left;border-top:3px solid black;width:150px;border-bottom: 1px solid black;line-height:120%;"><p style="margin-top:10px;margin-bottom:5px;">Notices to Mariners</p></td>
						<!-\-<td style="vertical-align:text-center;text-align:left;border-top: 3px solid black;width:150px;border-bottom: 1px solid black;">Notices to Mariners</td>-\->
					</tr>
					<xsl:call-template name="sub-class">
						<xsl:with-param name="result" select="msxsl:node-set($result)"/>
					</xsl:call-template>
				</table>
			</div>-->

			<!-- section header after the table information -->
			<xsl:call-template name="section-header">
				<xsl:with-param name="section-number">
					<xsl:value-of select="'IV'"/>
				</xsl:with-param>
			</xsl:call-template>

			<!-- Applying the notices information -->
			<xsl:apply-templates select="//NM_TORP_NTC[not(ancestor::CANCELLED_NOTICE_LIST)] | //NM_CHART_NTC"/>
		</div>
	</xsl:template>

	<xsl:template match="NM_MISC_SECTION">
		<div>
			<hr/>
			<h2 style="text-align:center"><xsl:value-of select="NAME"/></h2>
			<xsl:apply-templates select="SECTION_CONTENT_LIST/SECTION_CONTENT_LIST_ITEM"/>
		</div>
	</xsl:template>

	<!-- A template for each  Light list update section -->
	<xsl:template match="NM_SECTION_LIGHTLIST_PRODUCT">
		<!-- Make a division/section for the chart catalogue -->
		
		<xsl:variable name="nm_year">
			<xsl:if test="NM_YEAR_PUB = ''">
				<xsl:value-of select="XXXX/XX"/>
			</xsl:if>
		</xsl:variable>
		
		<div>
			<h6 style="text-align:center;font:arial;font-size:10pt;font-weight:bold;"><xsl:value-of select="concat('New Zealand Nautical Almanac ',NM_YEAR_PUB,$nm_year,', NZ 204')"/></h6><br/>
			<h6 style="text-align:center;font:arial;font-size:10pt;font-weight:bold;"><xsl:value-of select="'Light List Information'"/></h6>
			<!-- Apply the templates for each Notice -->
			
			<xsl:choose>
				<xsl:when test="not(SECTION_CONTENT_LIST)">
					<p style="text-align:center;">
						<xsl:value-of select="'Nil'"/>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<br/>
					<xsl:apply-templates select="SECTION_CONTENT_LIST/SECTION_CONTENT_LIST_ITEM"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<!-- A template for each  General section -->
	<xsl:template match="NTC_SECTION_GENERAL">
		<!-- Make a division/section for the General Section -->
		<div>
			<h2 style="text-align:center"><xsl:value-of select="NAME"/></h2>
			<!-- Apply the templates for each Notice -->
			<xsl:apply-templates select="SECTION_CONTENT_LIST/SECTION_CONTENT_LIST_ITEM"/>
		</div>
	</xsl:template>

	<!-- Template for Temporary or Preliminary Notices -->
	<xsl:template match="NM_TORP_NTC">
		<!--<br  style='margin-top:0pt'/>-->
		<div style="font-family:arial;font-size:9pt;">
			<table style="width:100%;">
				<tr>
					<td style="vertical-align:text-top;width:14%">
						<!-- If notice is prelim or temp show a (P) or (T) -->
						<xsl:variable name="term" >
							<xsl:choose>
								<xsl:when test="not(TERM)"/>
								<xsl:when test="TERM">
									<xsl:value-of select="concat('(',substring(TERM,1,1),')')"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<b>
							<xsl:value-of select="concat('NZ ',substring-before(PUBLISH_NUMBER,'/'),$term)"/>
							<xsl:value-of select="concat('/',substring-after(PUBLISH_NUMBER,'/'))"/>
						</b>
					</td>

					<!-- Region subregion vicinity subject-->
					<td style="vertical-align:text-top;width:88%;">
						<b>
							<xsl:if test="normalize-space(NZ_LOCALITY)">
								<xsl:value-of select="normalize-space(NZ_LOCALITY)"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="normalize-space(VICINITY)">
								<xsl:if test="normalize-space(NZ_LOCALITY)">
									<xsl:text>- </xsl:text>
								</xsl:if>
								<xsl:value-of select="VICINITY"/>
							</xsl:if>
							<xsl:if test="normalize-space(SUBJECT)">
								<xsl:if test="normalize-space(VICINITY)">
									<xsl:text>. </xsl:text>
								</xsl:if>
								<xsl:value-of select="SUBJECT"/>
							</xsl:if>
						</b></td></tr>
			</table>

			<ol>
				<xsl:if test="CANCELLED_NOTICE_LIST" >
					<xsl:variable name="pub-value">
						<xsl:for-each select="CANCELLED_NOTICE_LIST/CANCELLED_NOTICE_LIST_ITEM">
							<xsl:variable name="term">
								<xsl:if	test="normalize-space(NM_TORP_NTC/TERM)">
									<xsl:value-of select="concat('(',substring(NM_TORP_NTC/TERM,1,1),')')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="position()=last()-1">
									<xsl:value-of select="concat('NZ ',substring-before(NM_TORP_NTC/PUBLISH_NUMBER,'/'),$term,'/',substring-after(NM_TORP_NTC/PUBLISH_NUMBER,'/'), ' and ')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('NZ ',substring-before(NM_TORP_NTC/PUBLISH_NUMBER,'/'),$term,'/', substring-after(NM_TORP_NTC/PUBLISH_NUMBER,'/'),' ')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="conjunction">
						<xsl:choose>
							<xsl:when test="count(CANCELLED_NOTICE_LIST/CANCELLED_NOTICE_LIST_ITEM) > 1">
								<xsl:text> are cancelled.</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> is cancelled.</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<li style="margin-bottom:6pt;margin-top:15pt;">Former notice - <xsl:value-of select="concat($pub-value,$conjunction)"/></li>
					<xsl:if test="not(normalize-space(NM_TP_CONTENT/NM_TORP_INSTRUCTION)) and not(normalize-space(NM_TP_CONTENT/NM_TORP_LIST)) and not(normalize-space(NM_TP_CONTENT/NM_TORP_TABLE))">
						<li style="margin-bottom:6pt;margin-top:15pt;">Cancel this notice on receipt.</li>
					</xsl:if>
				</xsl:if>   
				<xsl:apply-templates select="NM_TP_CONTENT/NM_TORP_INSTRUCTION | NM_TP_CONTENT/NM_TORP_LIST | NM_TP_CONTENT/NM_TORP_TABLE"/>
			</ol>
						
			<xsl:if test="normalize-space(NM_CHART_AFFECTED_LIST/NM_CHART_AFFECTED) or normalize-space(NM_CHART_AFFECTED_LIST/CHART_NUM)">
			<b>
				<table>
					<tr>
						<xsl:variable name="nm_chart_affected" select="NM_CHART_AFFECTED_LIST/NM_CHART_AFFECTED"/>
						<xsl:choose>
							<xsl:when test="contains($nm_chart_affected,'Charts temporarily affected:')">
								<td style="width:170px ; vertical-align : top" >
									<b><span><xsl:value-of select="$nm_chart_affected"/></span></b>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td >
									<b><span style="text-align: right"><xsl:value-of select="$nm_chart_affected"/></span></b>
								</td>
							</xsl:otherwise>
						</xsl:choose>
						<td style=" text-align: justify;">
							<b>
							<xsl:apply-templates select="NM_CHART_AFFECTED_LIST/CHART_NUM"/>
							</b>
						</td>
					</tr>
				</table>
			</b><br/>
			</xsl:if>
			
			
			<xsl:if test="normalize-space(NM_NOTE)">
				<p style="margin-top:10px;margin-bottom:10px;font:arial;font-size:9pt;"><xsl:value-of select="NM_NOTE"/></p>
			</xsl:if>
			
		<!-- If the Notice is not original then display the issuing authority info at the end of the Notice -->
			<xsl:if test="NZ_AUTHORITY or HITS_NUMBER">
				<p style="font:arial;font-size:9pt;margin-bottom:0px;margin-top:0px">
					<xsl:if test="NM_NZ_LIGHTLIST !='' or NM_BALOL !=''">
					<xsl:if test="normalize-space(NM_NZ_LIGHTLIST)">
						<xsl:text>NZ Light List: </xsl:text><xsl:value-of select="NM_NZ_LIGHTLIST"/><br/>
					</xsl:if>
					<xsl:if test="normalize-space(NM_BALOL) and NM_BALOL !=''">
						<xsl:text>BA Light List (Volume K): </xsl:text><xsl:value-of select="NM_BALOL"/><br/>
					</xsl:if>
						<br/>
					</xsl:if>
					<xsl:if test="normalize-space(NZ_AUTHORITY)">
						<xsl:value-of select="NZ_AUTHORITY"/><br/>
					</xsl:if>
					<xsl:if test="normalize-space(HITS_NUMBER)">
						<xsl:value-of select="HITS_NUMBER"/>
					</xsl:if>
				</p>
				<xsl:if test="normalize-space(NM_TRACING) != 'No'">
					<br/><br/>
				</xsl:if>
			</xsl:if>
		</div>
		
	</xsl:template>

	<!-- Template for each permanent Chart Notice -->
	<xsl:template match="NM_CHART_NTC">
			<!-- Display the Notice Publish Number -->
			<table>
				<tr>
					<td style="margin-top:15pt;vertical-align:text-top;width:14%">
						<b>
							
							<xsl:variable name="publish_number">
								<xsl:choose>
									<xsl:when test="contains(PUBLISH_NUMBER,'NZ')">
										<xsl:value-of select="concat('NZ ',normalize-space(substring-after(PUBLISH_NUMBER,'NZ')))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat('NZ ',PUBLISH_NUMBER)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!--<xsl:text> PUBLISH_NUMBER </xsl:text>
							<xsl:value-of select="$publish_number"/>
							<xsl:text> *** </xsl:text>-->
							<!--<xsl:value-of select="concat('NZ ',substring-before(PUBLISH_NUMBER,'/'))"/>-->
							<xsl:value-of select="substring-before($publish_number,'/')"/>
							<xsl:if test="TERM">
								<xsl:value-of select="concat('(',substring(TERM,1,1),')')"/>
							</xsl:if>
							<xsl:value-of select="concat('/',substring-after($publish_number,'/'))"/>
						</b>
					</td>
					<td style="vertical-align:text-top;width:86%">
						<b>
							<xsl:if test="normalize-space(NZ_LOCALITY)">
								<xsl:value-of select="normalize-space(NZ_LOCALITY)"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="normalize-space(VICINITY)">
								<xsl:if test="normalize-space(NZ_LOCALITY)">
									<xsl:text>- </xsl:text>
								</xsl:if>
								<xsl:value-of select="VICINITY"/>
							</xsl:if>
							<xsl:if test="normalize-space(SUBJECT)">
								<xsl:if test="normalize-space(VICINITY)">
									<xsl:text>. </xsl:text>
								</xsl:if>
								<xsl:value-of select="SUBJECT"/>
							</xsl:if>
						</b>
					</td>
				</tr>
			</table>
		<xsl:if test="CANCELLED_NOTICE_LIST != ''">
		<ol style="margin-left:18pt;">
				<xsl:if test="CANCELLED_NOTICE_LIST" >
					<xsl:variable name="pub-value">
						<xsl:for-each select="CANCELLED_NOTICE_LIST/CANCELLED_NOTICE_LIST_ITEM">
							<xsl:variable name="term">
								<xsl:if	test="normalize-space(NM_TORP_NTC/TERM)">
									<xsl:value-of select="concat('(',substring(NM_TORP_NTC/TERM,1,1),')')"/>
								</xsl:if>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="position()=last()-1">
									<xsl:value-of select="concat('NZ ',substring-before(NM_TORP_NTC/PUBLISH_NUMBER,'/'),$term,'/',substring-after(NM_TORP_NTC/PUBLISH_NUMBER,'/'), ' and ')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('NZ ',substring-before(NM_TORP_NTC/PUBLISH_NUMBER,'/'),$term,'/', substring-after(NM_TORP_NTC/PUBLISH_NUMBER,'/'),' ')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
					                    <xsl:variable name="conjunction">
                        <xsl:choose>
                            <xsl:when test="count(CANCELLED_NOTICE_LIST/CANCELLED_NOTICE_LIST_ITEM) > 1">
                                <xsl:text> are cancelled.</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text> is cancelled.</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
	                    <li  >Former notice - <xsl:value-of select="concat($pub-value,$conjunction)"/></li>
				</xsl:if>   
			
<!--			<xsl:for-each select="SUBJECT_LIST/SUBJECT">
				<li>
				<xsl:copy-of select="."/>
				</li>
			</xsl:for-each>
-->		</ol>
		</xsl:if>
			
		
		<xsl:variable name="subject-count">
			<xsl:choose>
				<xsl:when test="CANCELLED_NOTICE_LIST">
					<xsl:value-of select="'1'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'0'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Make a table to show the chart catalogue updates -->
		
		<xsl:variable name="nm-chart-instructions">
			<xsl:for-each select="INSTRUCTION_LIST/INSTRUCTION_LIST_ITEM/NM_CHARTINSTRUCT">
				<xsl:sort select="translate(CHART_LIST/CHART/CHART_NUM,'NZ ','')" order="ascending" data-type="number"/>
				<xsl:sort select="CHART_LIST/CHART/PANEL/PANEL_NAME" order="ascending" data-type="text"/>
				<xsl:sort select="ACTION" data-type="text" order="descending"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>
    
		<xsl:call-template name="OutputChartInstructions">
			<xsl:with-param name="ChartInstructions" select="INSTRUCTION_LIST/INSTRUCTION_LIST_ITEM/NM_CHARTINSTRUCT"/>
			<xsl:with-param name="ShowChartHeader" select="'True'"/>
			<xsl:with-param name="level" select="$subject-count + 1"/>
			<xsl:with-param name="note" select="normalize-space(NM_NOTE)"/>
		</xsl:call-template>
		
		<br/><p style="font:arial;font-size:9pt;margin-bottom:0px;margin-top:0px">
			<xsl:if test="NM_NZ_LIGHTLIST !='' or NM_BALOL !=''">
			<xsl:if test="normalize-space(NM_NZ_LIGHTLIST)">
				<xsl:text>NZ Light List: </xsl:text><xsl:value-of select="NM_NZ_LIGHTLIST"/><br/>
			</xsl:if>
			<xsl:if test="normalize-space(NM_BALOL) and NM_BALOL !=''">
				<xsl:text>BA Light List (Volume K): </xsl:text><xsl:value-of select="NM_BALOL"/><br/>
			</xsl:if>
				<br/>
			</xsl:if>
			<xsl:if test="normalize-space(NZ_AUTHORITY)">
			<xsl:value-of select="NZ_AUTHORITY"/><br/>
			</xsl:if>
			<xsl:if test="normalize-space(HITS_NUMBER)">
			<xsl:value-of select="HITS_NUMBER"/>
			</xsl:if>
		</p>
		<xsl:if test="normalize-space(NM_TRACING) != 'No'">
			<br/><br/>
		</xsl:if>
		
		<xsl:if test="normalize-space(NM_TRACING) = 'No'">
			<p style="font:arial;font-size:9pt">Note: No tracings are included for this notice.</p><br/>
		</xsl:if>
	</xsl:template>

	<!-- Template for each attachment list -->
	<xsl:template match="ATTACHMENT_LIST">
		<xsl:variable name="format_date">
			<xsl:value-of select="../CHART_LIST/CHART/LAST_CORRECTION"/>
		</xsl:variable>
		<xsl:if test="ATTACHMENT != ''">
			<table border="0" style="margin:0px auto; width:95%;">
				<xsl:for-each select="ATTACHMENT">
					<xsl:if
						test="contains(FILENAME, '.jpg') or contains(FILENAME, '.bmp') or contains(FILENAME, '.gif') or contains(FILENAME, '.png') or contains(FILENAME, '.tif')">
						<tr><i><xsl:value-of select="ATT_DESCRIPTION"/></i></tr>
						<tr></tr>
						<tr><i><xsl:value-of select="LABEL"/></i></tr>
						<xsl:choose>
							<xsl:when test="NM_IMG_TYPE ='Others'">
								<!-- it should not display img for type others PDMD6977 -->
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<img>
										<xsl:attribute name="src">
											<xsl:value-of select="FILENAME"/>
										</xsl:attribute>
										<xsl:if test="NM_IMG_TYPE !=''">
											<xsl:attribute name="width">
												<xsl:value-of select="NM_IMAGE_SIZE/NM_IMAGE_WIDTH * 3.7795275590551"/>
											</xsl:attribute>
											<xsl:attribute name="height">
												<xsl:value-of select="NM_IMAGE_SIZE/NM_IMAGE_HEIGHT * 3.7795275590551"/>
											</xsl:attribute>
										</xsl:if>
									</img>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
						<tr>
							<xsl:if test="NM_IMG_TYPE='Block Correction'">
								<i>Image Size (mm) <xsl:value-of select="NM_IMAGE_SIZE/NM_IMAGE_HEIGHT"/> x <xsl:value-of select="NM_IMAGE_SIZE/NM_IMAGE_WIDTH"/></i>
							</xsl:if>
						</tr>
						<tr>
							<xsl:variable name="lbl"><xsl:value-of select="LABEL"/></xsl:variable>

							<xsl:if test="contains($lbl,'source data') or contains($lbl,'source Data') or contains($lbl,'Source Data') or contains($lbl,'Source data')">
								<div style="width:100%;">
								<table width="100%" style="border:solid 4px black;text-align:center;margin:0;padding:0;">
									<tr style="border-bottom:solid 1px red;">
										<td style="vertical-align:text-top;"><span style="font-size:8pt;align:right;margin-top:0px;"><i>Issued as a guide to chart correction. </i></span></td>
										<td colspan="2" style="vertical-align:text-top;"><span style="font-size:8pt;align:left;margin-top:0px;"><i>Use in conjunction with the appropriate NZ Notice to Mariners.</i></span></td>
									</tr>
									<tr  style="border: solid 0px;font:arial;font-size:9pt;font-weight:bold;">
										<td width="33.33%" style="border: solid 0px"><xsl:value-of select="'LAST CORRECTION'"/></td>
										<td width="33.33%" style="border: solid 0px"><xsl:value-of select="'NZ NTM No.'"/></td>
										<td width="33.33%" style="border: solid 0px"><xsl:value-of select="'CHART No.'"/></td>
									</tr>
									<tr style="font:arial;font-size:11pt;font-weight:bold;">
										<td style="border: solid 0px">
											<xsl:call-template name="format">
											<xsl:with-param name="datestr" select="$format_date"></xsl:with-param>
										</xsl:call-template></td>
										<td style="border: solid 0px"><xsl:value-of select="concat('NZ ',TAG)"/></td>
										<td style="border: solid 0px">
											<xsl:if test="normalize-space(translate(../../CHART_LIST/CHART/CHART_NUM,'NZ ',''))">
												<!--<xsl:value-of select="concat('NZ ',translate(../../CHART_LIST/CHART/CHART_NUM,'NZ ',''))"/>-->
												<!--<xsl:value-of select="concat('NZ ',translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))"/>-->
												<xsl:choose>
													<xsl:when test="../../CHART_LIST/CHART/CHART_INT_NUM">
														<!--<xsl:value-of select="concat('NZ ',translate(.,'NZ ',''),'(',..//CHART_INT_NUM,')',',')"/>-->
														
														<xsl:value-of select="concat(../../CHART_LIST/CHART/CHART_NUM,'(',../../CHART_LIST/CHART/CHART_INT_NUM,')')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="../../CHART_LIST/CHART/CHART_NUM"/>
													</xsl:otherwise>
												</xsl:choose>	
											</xsl:if>
										</td>
									</tr>
								</table>
								</div>
							</xsl:if>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ATTACHMENT_LIST" mode="sect-v">
		<br/>
		<xsl:if test="ATTACHMENT != ''">
			<table border="0" style="margin:0px auto; width:95%;">
				<xsl:for-each select="ATTACHMENT">
					<xsl:if test="contains(FILENAME, '.jpg') or contains(FILENAME, '.bmp') or contains(FILENAME, '.gif') or contains(FILENAME, '.png') or contains(FILENAME, '.tif')">
						<tr>
							<img width="650">
								<xsl:attribute name="src">
									<xsl:value-of select="FILENAME"/>
								</xsl:attribute>
							</img>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</table>
		</xsl:if>
	</xsl:template>
	
	<!-- Template to output sets of instructions for each chart set,  flag to show header for each set -->
	<xsl:template name="OutputChartInstructions">

		<!-- Node list of NM_CHARTINSTRUCT to process -->
		<xsl:param name="ChartInstructions"/>

		<!-- True if the header should be shown, if there are multiple chart sets in one notice -->
		<xsl:param name="ShowChartHeader"/>

		<!-- Sequence number of list-item to be start with -->
		<xsl:param name="level"/>
		
		<xsl:param name="note"/>

		<!--  See if we have something to process -->
		<xsl:if test="$ChartInstructions">
			<!-- first chart number -->
			<xsl:variable name="curChartList" select="$ChartInstructions[1]/CHART_LIST/CHART/CHART_NUM"/>
			
			<!-- first panel name -->
			<xsl:variable name="curPanelName" select="normalize-space($ChartInstructions[1]/CHART_LIST/CHART/PANEL/PANEL_NAME)"/>

			<!-- for each instruction for the same set of chart -->
			<xsl:for-each select="$ChartInstructions[./CHART_LIST/CHART/CHART_NUM = $curChartList and normalize-space(./CHART_LIST/CHART/PANEL/PANEL_NAME) = $curPanelName]">
				<!--<span style="margin-bottom:6pt;margin-top:6pt">-->
				<p style="margin-bottom:1pt;">
					<!--  if show header, Show a header using the the charts referenced by the first instruction -->
					<xsl:if test="$ShowChartHeader = 'True' and position() = 1">
						<!-- Output all the charts in the list -->
							<b>
								<xsl:if test="CHART_LIST/CHART/CHART_NUM">
									<xsl:value-of select="$level"/>
									<xsl:text>. Chart </xsl:text>
									<xsl:if test="normalize-space(translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))">
										<!--<xsl:value-of select="concat('NZ ',translate(CHART_LIST/CHART/CHART_NUM,'NZ ',''))"/>-->
										<xsl:choose>
											<xsl:when test="contains(CHART_LIST/CHART/CHART_NUM,'NZ')">
												<xsl:value-of select="concat('NZ ',normalize-space(substring-after(CHART_LIST/CHART/CHART_NUM,'NZ')))"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat('NZ ',CHART_LIST/CHART/CHART_NUM)"/>
											</xsl:otherwise>
										</xsl:choose>
										
										
										<xsl:if test="CHART_LIST/CHART/CHART_INT_NUM">
											<xsl:text>&#160;(</xsl:text>
											<xsl:value-of select="(CHART_LIST/CHART/CHART_INT_NUM)"/>
											<xsl:text>)</xsl:text>
										</xsl:if>
										
									</xsl:if>
								</xsl:if>
								<!-- if panel name is not equal to chart title then we should not show plan text-->
								<xsl:variable name="count_chart_num">
									<xsl:value-of select="count(../../INSTRUCTION_LIST_ITEM/NM_CHARTINSTRUCT/CHART_LIST/CHART/CHART_NUM)" />
								</xsl:variable>
								<xsl:variable name="chart_num">
								<xsl:for-each select=".">
									<xsl:value-of select="../../INSTRUCTION_LIST_ITEM/NM_CHARTINSTRUCT/CHART_LIST/CHART/CHART_NUM"/>
								</xsl:for-each>
								</xsl:variable>
								<xsl:variable name="chart_title">
									<xsl:for-each select=".">
										<xsl:value-of select="../../INSTRUCTION_LIST_ITEM/NM_CHARTINSTRUCT/CHART_LIST/CHART/CHART_TITLE"/>
									</xsl:for-each>
								</xsl:variable>
								<!--<xsl:text> Panel Name = </xsl:text><xsl:value-of select="$chart_title "/>
								<xsl:text> Chart list Panel Name = </xsl:text><xsl:value-of select="CHART_LIST/CHART/PANEL/PANEL_NAME "/>								
								<xsl:text> Instruction list Chart Name = </xsl:text><xsl:value-of select="$chart_num"/>
								<xsl:text> Chart Name = </xsl:text><xsl:value-of select="CHART_LIST/CHART/CHART_NUM"/>-->
								
								<!--<xsl:if test="$count_chart_num = 1 or (CHART_LIST/CHART/CHART_NUM = $chart_num and CHART_LIST/CHART/PANEL/PANEL_NAME != $chart_title)">
								<!-\-<xsl:if test="$count_chart_num = 1 ">-\->
                                <xsl:text> (</xsl:text>
								<xsl:if test="CHART_LIST/CHART/PANEL/PANEL_NAME != CHART_LIST/CHART/CHART_TITLE ">
									<xsl:text>plan</xsl:text>
								</xsl:if>
									<xsl:if test="../../../NM_PLAN ='Yes'">
										<xsl:text>, </xsl:text>
								<xsl:value-of select="CHART_LIST/CHART/PANEL/PANEL_NAME"/>
									</xsl:if>
								<xsl:text>)</xsl:text>
								</xsl:if>-->
								
								
								<!--<xsl:if test="NM_PLAN ='Yes'">
									<xsl:text>&#160;(</xsl:text>
									<xsl:value-of select="CHART_LIST/CHART/PANEL/PANEL_NAME"/>
									<xsl:text>)</xsl:text>
								</xsl:if>-->
								
								
								<xsl:if test="CHART_LIST/CHART/CHART_INT_NUM">
									<!--<xsl:text>(INT </xsl:text>
									<xsl:value-of select="CHART_LIST/CHART/PANEL/PANEL_NAME"/>
										<xsl:text>)</xsl:text>-->
								</xsl:if>
								
								
								<xsl:if test="NM_PLAN ='Yes'">
									<xsl:if test="CHART_LIST/CHART/CHART_TITLE != CHART_LIST/CHART/PANEL/PANEL_NAME">
										<xsl:value-of select="concat('&#160;(plan,&#160;',CHART_LIST/CHART/PANEL/PANEL_NAME)"/>
										<xsl:text>)</xsl:text>
									</xsl:if>
									
									<xsl:if test="CHART_LIST/CHART/CHART_TITLE = CHART_LIST/CHART/PANEL/PANEL_NAME">
										<xsl:value-of select="concat('&#160;(',CHART_LIST/CHART/PANEL/PANEL_NAME)"/>
										<xsl:text>)</xsl:text>
									</xsl:if>
								</xsl:if>
								
								<xsl:if test="NM_PLAN ='No'">
									
								</xsl:if>
								
								<xsl:if test="not(NM_PLAN)">
									<xsl:if test="CHART_LIST/CHART/CHART_TITLE != CHART_LIST/CHART/PANEL/PANEL_NAME">
										<xsl:value-of select="concat('&#160;(plan,&#160;',CHART_LIST/CHART/PANEL/PANEL_NAME)"/>
										<xsl:text>)</xsl:text>
									</xsl:if>
								</xsl:if>
								
								
								<xsl:variable name="last_correction">
									<xsl:value-of select="CHART_LIST/CHART/LAST_CORRECTION"/>
								</xsl:variable>
								<xsl:variable name="edition_date">
									<xsl:value-of select="CHART_LIST/CHART/EDITION_DATE"/>
								</xsl:variable>
								<xsl:if test="CHART_LIST/CHART/LAST_CORRECTION !='' or CHART_LIST/CHART/EDITION_DATE !=''">
									<xsl:element name="i">
										<xsl:attribute name="style">
											<xsl:value-of select="'font-weight:normal;'"/>
										</xsl:attribute>
										<xsl:text> [ </xsl:text>
										<xsl:choose>
											<xsl:when test="CHART_LIST/CHART/LAST_CORRECTION != '0' and CHART_LIST/CHART/LAST_CORRECTION != ''">
												<xsl:element name="LAST_CORRECTION">
													<xsl:call-template name="lastdateformat">
														<xsl:with-param name="datestr" select="$last_correction"></xsl:with-param>
													</xsl:call-template>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="editiondateformat">
													<xsl:with-param name="datestr" select="$edition_date"></xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:text> ]</xsl:text>
									</xsl:element>
								</xsl:if>
								<!-- no need of edition_date -->
								<!--<xsl:if test="CHART_LIST/CHART/LAST_CORRECTION !=''">
									<xsl:element name="i">
									<xsl:attribute name="style">
										<xsl:value-of select="'font-weight:normal;'"/>
									</xsl:attribute>
									<xsl:text> [ </xsl:text>
									<xsl:value-of select="CHART_LIST/CHART/LAST_CORRECTION"/>
									<xsl:text> ]</xsl:text>
									</xsl:element>
								</xsl:if>-->
							</b>

						<xsl:if test="normalize-space($note)">
							<br/>
							<xsl:value-of select="concat('Note: ',normalize-space($note))"/>
						</xsl:if>
					</xsl:if>
					<!--<xsl:text> ChartInstruction </xsl:text>
					<xsl:value-of select="."/>
					<xsl:text> *** </xsl:text>-->
					<!--Apply the template for each instruction-->
					<xsl:call-template name="OutputChartInstruction">
						<xsl:with-param name="ChartInstruction" select="."/>
						<xsl:with-param name="pos" select="position()"/>
						<xsl:with-param name="chart-count" select="count($ChartInstructions/CHART_LIST)"/>
						<xsl:with-param name="prev-action" select="./preceding::ACTION[1]"/>
					</xsl:call-template>

					<b><xsl:value-of select="./REMARKS"/></b>
				<!--</span>-->
				</p>
			</xsl:for-each>

			<!--Select all the nodes referring to the different charts as the first entry in the list,  and call this template to process them, using header flag passed in -->
			<xsl:if test="$curChartList">
				
				<xsl:call-template name="OutputChartInstructions">
					<xsl:with-param name="ChartInstructions"
						select="$ChartInstructions[not(concat(./CHART_LIST/CHART/CHART_NUM,./CHART_LIST/CHART/PANEL/PANEL_NAME[normalize-space()]) = concat($curChartList,$curPanelName))]"/>
					<xsl:with-param name="ShowChartHeader" select="$ShowChartHeader"/>
					<xsl:with-param name="level" select="$level+1"/>
					<xsl:with-param name="note" select="$note"/>
				</xsl:call-template>
			</xsl:if>

		</xsl:if>
	</xsl:template>

	<!-- Template to output the contents of the instruction -->
	<xsl:template name="OutputChartInstruction">
		<xsl:param name="ChartInstruction"/>
		<xsl:param name="pos"/>
		<xsl:param name="chart-count"/>
		<xsl:param name="prev-action"/>
		<xsl:if test="$ChartInstruction">
			<table border="0" style="margin:0px auto; width:95%;">
				<tr valign="top" align="left">
					<!-- Apply the template for the action -->
					<td style="width:10%;">
<!--						<xsl:value-of select="concat('p: ',$prev-action,'c:',$ChartInstruction/ACTION)"/>
						<br/>
-->						<xsl:if test="$pos = 1 or normalize-space($prev-action) != normalize-space($ChartInstruction/ACTION)">
							<xsl:apply-templates select="$ChartInstruction/ACTION"/>
						</xsl:if>
					</td>

					<!-- Show the description-->
					<td style="width:55%;">
						<xsl:apply-templates select="$ChartInstruction/DESCRIPTION"/>
					</td>
<!--					<xsl:if test="$pos=1 and $chart-count > 1">-->
						<td  style="width:4%;">
							<xsl:value-of select="''"/>
					</td>
					<!--</xsl:if>-->
						
					<!-- Apply the templates for each set of positions-->
					<td style="width:40%;">
						<xsl:apply-templates select="$ChartInstruction/POSITION_LIST"/>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>

	<!-- The template for each set of positions-->
	<xsl:template match="DESCRIPTION">
		<xsl:copy-of select="child::node()"/>
	</xsl:template>

	<!-- The template for each set of positions-->
	<xsl:template match="POSITION_LIST">
		<table border="0">
			<!-- Apply the template for each position -->
			<xsl:apply-templates select="POSITION"/>
		</table>
	</xsl:template>

	<!-- The template for each position-->
	<xsl:template match="POSITION">
		<tr>
			<!-- If there is a position tag show it -->
			<td>
				<xsl:if test="normalize-space(TAG)">
					<xsl:value-of select="normalize-space(TAG)"/>
    <!--	Below line commented for avoiding positions moving to two lines(done by ali)				-->
					<!--<xsl:text>: </xsl:text>-->
				</xsl:if>
			</td>

			<!-- Show the lat and long -->
			<td>
				<xsl:variable name="chartscale">
					<!--<xsl:value-of select="normalize-space(../../../NM_CHARTINSTRUCT/CHART_LIST/CHART/PANEL/CHART_SCALE)"/>-->
					
					<xsl:value-of select="translate(../../../NM_CHARTINSTRUCT/CHART_LIST/CHART/PANEL/CHART_SCALE,',','')"/>
				</xsl:variable>
				<!--<xsl:text> chartscale </xsl:text>
				<xsl:value-of select="$chartscale"/>
				<xsl:text> $$$ </xsl:text>-->
				<xsl:variable name="p">
					<!-- we dont need consider NM_PRECISION for latlog precisition, as it is depends on the CHART_SCALE value  -->
					<!--<xsl:choose>
						<xsl:when test="normalize-space(../../NM_PRECISION)">
							<xsl:value-of select="normalize-space(../../NM_PRECISION)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'2'"/>
						</xsl:otherwise>
					</xsl:choose>-->
					<xsl:choose>
						<xsl:when test="normalize-space(../../NM_PRECISION) = ''">
					<xsl:choose>
						<xsl:when test="$chartscale &gt; 10000">
							<xsl:value-of select="2"/>
						</xsl:when>
						<xsl:when test="$chartscale &lt;= 10000">
							<xsl:value-of select="3"/>
						</xsl:when>
					</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../../NM_PRECISION"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="normalize-space(LATITUDE) and not(normalize-space(POS_DESCRIPTION))">
					<!--<xsl:text> Precision </xsl:text>
					<xsl:value-of select="$p"/>
					<xsl:text> **** </xsl:text>-->
					<xsl:call-template name="FormatLatLong">
						<xsl:with-param name="Coordinate" select="normalize-space(LATITUDE)"/>
						<xsl:with-param name="Precision" select="$p"/>
					</xsl:call-template>
					<xsl:text>,</xsl:text>
				</xsl:if>
				<xsl:if test="normalize-space(LONGITUDE) and not(normalize-space(POS_DESCRIPTION))">
					<!--<xsl:text> Precision </xsl:text>
					<xsl:value-of select="$p"/>
					<xsl:text> **** </xsl:text>-->
					<xsl:call-template name="FormatLatLong">
						<xsl:with-param name="Coordinate" select="normalize-space(LONGITUDE)"/>
						<xsl:with-param name="Precision" select="$p"/>
					</xsl:call-template>
				</xsl:if>
			</td>
			<td>
				<!-- Show the description-->
				<xsl:copy-of select="POS_DESCRIPTION"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="ACTION">
		<xsl:choose>
			<xsl:when test=". = 'Modify'">
				<xsl:text>Amend</xsl:text>
			</xsl:when>
			<xsl:when test=". = 'Replace'">
				<xsl:text>Replace</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<xsl:template name="LatDDtoDDM">
    <!-- Coordinate string to format, expected signed decimal degrees -->
    <!-- output like dd°mm'.00S. -->
    <xsl:param name="Coordinate"/>
	<xsl:param name="scale"/>
    <xsl:param name="decimalFormat" select="00.0000"/>
	<!--<xsl:text> Coordinate </xsl:text>
	<xsl:value-of select="$Coordinate"/>
	<xsl:text> *** </xsl:text>-->
    <xsl:if test="number($Coordinate) = $Coordinate">
        <xsl:variable name="base">
            <xsl:choose>
                <xsl:when test="starts-with($Coordinate, '-')">
                    <xsl:value-of select="substring-after($Coordinate,'-')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$Coordinate"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable> 
        <xsl:variable name="deg">
            <xsl:choose>
                <xsl:when test="contains($base, '.')">
                    <xsl:value-of select="substring-before($base, '.')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="format-number($deg,'00')"/>
        <xsl:text>° </xsl:text>

    	<!--<xsl:variable name="latdm" select="substring(($base - $deg) * 60,1,5)" />-->
    	<xsl:variable name="decimal_min_val" select="round(100*($base - $deg) * 60) div 100"/>
    	<!--<xsl:variable name="latdm" select="format-number($decimal_min_val ,'##0.000' )"/>-->
    	
    	<xsl:variable name="latdm">
    		<xsl:choose>
    			<xsl:when test="$scale &lt;= 10000">
    				<xsl:value-of select="format-number($decimal_min_val ,'##0.000')"/>
    			</xsl:when>
    			<xsl:otherwise>
    				<xsl:value-of select="format-number($decimal_min_val ,'##0.00')"/>
    			</xsl:otherwise>
    		</xsl:choose>
    	</xsl:variable>
    	
    	<!--<xsl:text> decimal_min_val </xsl:text>
    	<xsl:value-of select="$decimal_min_val"/>
    	<xsl:text> $$$ </xsl:text>
    	<xsl:text>latdm </xsl:text>
    	<xsl:value-of select="$latdm"/>
    	<xsl:text> format-number latdm </xsl:text>
    	<xsl:value-of select="format-number($latdm ,'#' )"/>
    	<xsl:text> *** </xsl:text>
    	<xsl:text> substring-after($latdm, '.') </xsl:text>
    	<xsl:value-of select="substring-after($latdm, '.')"/>
    	<xsl:text> *** </xsl:text>-->
    	<!--<xsl:text>latdm </xsl:text>
    	<xsl:value-of select="$latdm"/>
    	<xsl:text> *** </xsl:text>
    	<xsl:text> substring-before($latdm, '.') </xsl:text>
    	<xsl:value-of select="string-length(substring-before($latdm, '.')) "/>
    	<xsl:text> *** </xsl:text>-->
        <xsl:choose>
            <xsl:when test="contains($latdm, '.')">
            	<xsl:choose>
            		<xsl:when test="string-length(substring-before($latdm, '.')) = 1">
            			<xsl:value-of select="concat('0',substring-before($latdm, '.'))"/>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:value-of select="substring-before($latdm, '.')"/>
            		</xsl:otherwise>
            	</xsl:choose>
                <xsl:text>'.</xsl:text>
            	<xsl:value-of select="substring-after($latdm, '.')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$latdm"/>
                <xsl:text>'</xsl:text>
            	<xsl:choose>
            		<xsl:when test="$scale &lt;= 10000">
            			<xsl:value-of select="'000'"/>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:value-of select="'00'"/>
            		</xsl:otherwise>
            	</xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="starts-with($Coordinate, '-')">
                <xsl:text>S.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>N.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>

</xsl:template>
<xsl:template name="LonDDtoDDM">
    <!-- Coordinate string to format, expected signed decimal degrees -->
    <!-- output like ddd°mm'.00E. -->
    <xsl:param name="Coordinate"/>
	<xsl:param name="scale"/>
    <xsl:param name="decimalFormat" select="00.00"/>
	<!--<xsl:text> Coordinate </xsl:text>
	<xsl:value-of select="$Coordinate"/>
	<xsl:text> *** </xsl:text>-->
    <xsl:if test="number($Coordinate) = $Coordinate">
        <xsl:variable name="base">
            <xsl:choose>
                <xsl:when test="starts-with($Coordinate, '-')">
                    <xsl:value-of select="substring-after($Coordinate,'-')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$Coordinate"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable> 
        <xsl:variable name="deg">
            <xsl:choose>
                <xsl:when test="contains($base, '.')">
                    <xsl:value-of select="substring-before($base, '.')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="format-number($deg,'000')"/>
        <xsl:text>° </xsl:text>

    	<!--<xsl:variable name="dm" select="substring(($base - $deg) * 60,1,5)" />-->
    	<xsl:variable name="dm">
    	<xsl:choose>
    		<xsl:when test="$scale &lt;= 10000">
    			<xsl:value-of select="format-number( round(100*($base - $deg) * 60) div 100 ,'##0.000' )"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<xsl:value-of select="format-number( round(100*($base - $deg) * 60) div 100 ,'##0.00' )"/>
    		</xsl:otherwise>
    	</xsl:choose>
    	</xsl:variable>
    	<!--<xsl:text> substring(($base - $deg) </xsl:text>
    	<xsl:value-of select="($base - $deg)* 60"/>
    	<xsl:text> substring(($base - $deg) * 60,1,5) </xsl:text>
    	<xsl:value-of select="substring(($base - $deg) * 60,1,5)"/>
    	<xsl:text> *** </xsl:text>-->
        <xsl:choose>
            <xsl:when test="contains($dm, '.')">
            	<xsl:choose>
            		<xsl:when test="string-length(substring-before($dm, '.')) = 1">
            			<xsl:value-of select="concat('0',substring-before($dm, '.'))"/>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:value-of select="substring-before($dm, '.')"/>
            		</xsl:otherwise>
            	</xsl:choose>
                <xsl:text>'.</xsl:text>
            	<xsl:value-of select="substring-after($dm, '.')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$dm"/>
                <xsl:text>'</xsl:text>
            	<xsl:choose>
            		<xsl:when test="$scale &lt;= 10000">
            			<xsl:value-of select="'000'"/>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:value-of select="'00'"/>
            		</xsl:otherwise>
            	</xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
            <xsl:when test="starts-with($Coordinate, '-')">
                <xsl:text>W.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>E.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>

</xsl:template>

	<!-- template to format Lat/Long into deg, min and optionally seconds with associated symbols 24 12' 52.4" N 110 18' 20.63" W
	Takes in deg-min-sec Q  like 24-12-52.4N 110-18-20.63W.  Does one coordinate at a time -->
	<xsl:template name="FormatLatLong">
		<!-- Coordinate string to format -->
		<xsl:param name="Coordinate"/>
		<xsl:param name="Precision" select="2"/>
		
		<xsl:choose>
			<!-- If the string is empty spit out "Error, Empty Coordinate" -->
			<xsl:when test="$Coordinate = ''">
				<xsl:text>Error, Empty Coordinate</xsl:text>
			</xsl:when>
			<!-- If the string is already formatted (found degree symbol) just spit it out -->
			<xsl:when test="contains($Coordinate, '°')">
				<xsl:value-of select="$Coordinate"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Identify the separator to use for parsing the string -->
				<xsl:variable name="Separator">
					<xsl:choose>
						<xsl:when test="contains($Coordinate, '-')">
							<!-- Assumes no negative coords -->
							<xsl:text>-</xsl:text>
						</xsl:when>
						<xsl:when test="contains($Coordinate, '.')">
							<xsl:text>.</xsl:text>
						</xsl:when>
						<xsl:when test="contains($Coordinate, ' ')">
							<xsl:text> </xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				
				<!-- Identify the quadrant character, expected at the end of the string -->
				<xsl:variable name="Quadrant">
					<xsl:choose>
						<xsl:when test="contains($Coordinate, 'N')">
							<xsl:text>N</xsl:text>
						</xsl:when>
						<xsl:when test="contains($Coordinate, 'S')">
							<xsl:text>S</xsl:text>
						</xsl:when>
						<xsl:when test="contains($Coordinate, 'E')">
							<xsl:text>E</xsl:text>
						</xsl:when>
						<xsl:when test="contains($Coordinate, 'W')">
							<xsl:text>W</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>?</xsl:text>
						</xsl:otherwise>
						
					</xsl:choose>
				</xsl:variable>
				
				<!-- Get the original Coordinate without the Quadrant -->
				<xsl:variable name="BareCoord">
					<xsl:value-of select="substring-before($Coordinate, $Quadrant) "/>
				</xsl:variable>
				
				<!-- Get the Degrees -->
				<xsl:variable name="Degrees">
					<xsl:value-of select="substring-before($BareCoord, $Separator)"/>
				</xsl:variable>
				
				<!-- Get the MinSecs -->
				<xsl:variable name="MinSecs">
					<xsl:value-of select="($BareCoord - $Degrees)"/>
				</xsl:variable>
				
				<!-- Get the Minutes -->
				<xsl:variable name="Minutes">
					<xsl:value-of select="format-number(($MinSecs * 60),'##.######')"/>
				</xsl:variable>
				<xsl:variable name="Minutes_modified">
				<xsl:if test="$Minutes != ''">
					<xsl:choose>
						<xsl:when test="not(contains($Minutes,'.'))">
					    <xsl:value-of select="concat($Minutes,'.')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$Minutes"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				</xsl:variable>
				<!--<xsl:text> Minutes  </xsl:text>
				<xsl:value-of select="$Minutes"/>
				<xsl:text> ***** </xsl:text>-->
				<!--<xsl:if test="$Degrees != ''">
					<xsl:value-of select="$Degrees"/>
					<xsl:text>°</xsl:text>
				</xsl:if>-->
				<xsl:text> </xsl:text>
				<xsl:variable name="decimals_var">
					<xsl:value-of select="substring(substring-after($Minutes_modified,$Separator),1,$Precision+1)"/>
				</xsl:variable>
				<xsl:variable name="min_before_precision">
					<xsl:value-of select="substring-after($Minutes_modified,$Separator)"/>
				</xsl:variable>
				
				<xsl:variable name="decimal_mins">
					<xsl:value-of select="substring(substring-after($Minutes_modified,$Separator),1,$Precision)"/>
				</xsl:variable>
				<xsl:variable name="original_decimals_after_min">
					<xsl:value-of select="string-length(substring-after($Minutes_modified,$Separator))"/>
				</xsl:variable>
				<xsl:variable name="extra_val">
					
						<xsl:value-of select="substring($decimals_var,$Precision+1,1)"/>
					
				</xsl:variable>
				<!--<xsl:text> $extra_val </xsl:text>
				<xsl:value-of select="$extra_val"/>
				<xsl:text> *** </xsl:text>-->
				<xsl:choose>
					
					<xsl:when test="$extra_val &gt;= 5 and string-length($decimal_mins) &gt;= $Precision">
						<xsl:variable name="min_with_decimal">
							<xsl:value-of select="concat(substring-before($Minutes_modified,'.'),'.',$decimal_mins)"/>		
						</xsl:variable>
						
						<!--<xsl:text> $min_with_decimal </xsl:text>
						<xsl:value-of select="$min_with_decimal"/>
						<xsl:text> *** </xsl:text>-->
						<!--<xsl:text> $Precision </xsl:text>
						<xsl:value-of select="$Precision"/>
						<xsl:text> *** </xsl:text>	-->
						<xsl:variable name="precision_min_with_decimal">
							<xsl:choose>
								<xsl:when test="$Precision = 1">
									<!--<xsl:value-of select="($min_with_decimal)+(0.01)"/>-->
									<xsl:value-of select="format-number($min_with_decimal + 0.1, '##.######')"/>
								</xsl:when>
								<xsl:when test="$Precision = 2">
									<!--<xsl:value-of select="($min_with_decimal)+(0.01)"/>-->
									<xsl:value-of select="format-number($min_with_decimal + 0.01, '##.######')"/>
								</xsl:when>
								<xsl:when test="$Precision = 3">
									<!--<xsl:value-of select="($min_with_decimal)+(0.001)"/>-->
									<xsl:value-of select="format-number($min_with_decimal + 0.001, '##.######')"/>
								</xsl:when>
								<xsl:when test="$Precision = 4">
									<!--<xsl:value-of select="($min_with_decimal)+(0.01)"/>-->
									<xsl:value-of select="format-number($min_with_decimal + 0.0001, '##.######')"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="modified_min_with_decimal">
							<xsl:choose>
								<xsl:when test="not(contains($precision_min_with_decimal,'.'))">
									<xsl:value-of select="concat($precision_min_with_decimal,'.')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$precision_min_with_decimal"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<!--<xsl:text> precision_min_with_decimal </xsl:text>
						<xsl:value-of select="$precision_min_with_decimal"/>
						<xsl:text> *** </xsl:text>
						<xsl:text> modified_min_with_decimal </xsl:text>
						<xsl:value-of select="$modified_min_with_decimal"/>
						<xsl:text> *** </xsl:text>-->
						<xsl:variable name="final_minutes" select="substring-before($modified_min_with_decimal,$Separator)"/>
						<xsl:choose>
							<xsl:when test="$final_minutes = 60">
								<xsl:if test="$Degrees != ''">
									<xsl:value-of select="$Degrees+1"/>
									<xsl:text>°</xsl:text>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$Degrees != ''">
									<xsl:value-of select="$Degrees"/>
									<xsl:text>°</xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						
						<xsl:choose>
							<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=0">
								<xsl:choose>
									<!-- If the string is  having hyphen symbol (-) symbol format it-->
									<xsl:when test="contains($Coordinate,'-')">
										<xsl:value-of select="substring-before(substring-after($Coordinate,'-'),'.')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>00</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								
							</xsl:when>
							<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=1">
								<xsl:value-of select="concat('0',substring-before($Minutes_modified,$Separator))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$final_minutes = 60">
										<xsl:text>00</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring-before($modified_min_with_decimal,$Separator)"/>
									</xsl:otherwise>
								</xsl:choose>
								
							</xsl:otherwise>
						</xsl:choose>
						<xsl:variable name="decimals_after_min" select="substring-after($modified_min_with_decimal,$Separator)"/>
						<xsl:text>'.</xsl:text>
						<!--<xsl:text> $modified_min_with_decimal </xsl:text>
						<xsl:value-of select="$modified_min_with_decimal"/>
						<xsl:text> *** </xsl:text>
						<xsl:text> $Precision </xsl:text>
						<xsl:value-of select="$Precision"/>
						<xsl:text> *** </xsl:text>-->
						<xsl:choose>
							<xsl:when test="$decimals_after_min = '' ">
								<!-- if we don't have any decimalvalues after minutes-->
								<xsl:value-of select="substring(concat(substring-after($modified_min_with_decimal,$Separator),'000'),1,$Precision)"/>
							</xsl:when>
							<xsl:when test="string-length(substring-after($modified_min_with_decimal,$Separator))= $Precision ">
								<xsl:value-of select="substring(substring-after($modified_min_with_decimal,$Separator),1,$Precision)"/>
							</xsl:when>
							<xsl:when test="$Precision - string-length( substring-after($modified_min_with_decimal,$Separator)) = 1">
								
								<xsl:value-of select="substring(concat(substring-after($modified_min_with_decimal,$Separator),'0'),1,$Precision)"/>
							</xsl:when>
							<xsl:when test="$Precision - string-length( substring-after($modified_min_with_decimal,$Separator)) = 2">
								
								<xsl:value-of select="substring(concat(substring-after($modified_min_with_decimal,$Separator),'00'),1,$Precision)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(substring-after($modified_min_with_decimal,$Separator),1,$Precision)"/>
							</xsl:otherwise>
						</xsl:choose>
						<!--<xsl:text> above five min_with_decimal </xsl:text>
						<xsl:value-of select="$min_with_decimal"/>
						<xsl:text> *** </xsl:text>
						<xsl:text> precision_min_with_decimal </xsl:text>
						<xsl:value-of select="$precision_min_with_decimal"/>
						<xsl:text> *** </xsl:text>-->
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="min_with_decimal">
							<xsl:value-of select="concat(substring-before($Minutes_modified,'.'),'.',$decimal_mins)"/>		
						</xsl:variable>
						<xsl:variable name="final_minutes" select="substring-before($min_with_decimal,$Separator)"/>
						<xsl:choose>
							<xsl:when test="$final_minutes = 60">
								<xsl:if test="$Degrees != ''">
									<xsl:value-of select="$Degrees+1"/>
									<xsl:text>°</xsl:text>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								
								<xsl:if test="$Degrees != ''">
									<xsl:value-of select="$Degrees"/>
									<xsl:text>°</xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=0">
								<xsl:choose>
									<!-- If the string is  having hyphen symbol (-) symbol format it-->
									<xsl:when test="contains($Coordinate,'-')">
										<xsl:value-of select="substring-before(substring-after($Coordinate,'-'),'.')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>00</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								
							</xsl:when>
							<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=1">
								<xsl:value-of select="concat('0',substring-before($Minutes_modified,$Separator))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
								<xsl:when test="$final_minutes = 60">
									<xsl:text>00</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-before($min_with_decimal,$Separator)"/>
								</xsl:otherwise>
						    </xsl:choose>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:text>'.</xsl:text>
						<!--<xsl:text> $Minutes </xsl:text>
						<xsl:value-of select="$Minutes"/>
						<xsl:text> $$$ </xsl:text>
						<xsl:text> $Minutes_modified </xsl:text>
						<xsl:value-of select="$Minutes_modified"/>
						<xsl:text> $$$ </xsl:text>
						<xsl:text> below five min_with_decimal </xsl:text>
						<xsl:value-of select="$min_with_decimal"/>
						<xsl:text> *** </xsl:text>-->
						<xsl:choose>
							
							<xsl:when test="string-length(substring-after($min_with_decimal,$Separator))= $Precision ">
								<xsl:value-of select="substring(substring-after($min_with_decimal,$Separator),1,$Precision)"/>
							</xsl:when>
							<xsl:when test="$Precision - string-length( substring-after($min_with_decimal,$Separator)) = 1">
								
								<xsl:value-of select="substring(concat(substring-after($min_with_decimal,$Separator),'0'),1,$Precision)"/>
							</xsl:when>
							<xsl:when test="$Precision - string-length( substring-after($min_with_decimal,$Separator)) = 2">
								
								<xsl:value-of select="substring(concat(substring-after($min_with_decimal,$Separator),'00'),1,$Precision)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(substring-after($min_with_decimal,$Separator),1,$Precision)"/>
							</xsl:otherwise>
						</xsl:choose>
						<!--<xsl:value-of select="substring-after($min_with_decimal,$Separator)"/>-->
						
						
					</xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="decimal_val">
					<xsl:value-of select="substring($decimals_var,1,string-length($decimals_var)-1)"/>
				</xsl:variable>
				
				
				<!--<xsl:text> $Minutes_modified </xsl:text>
				<xsl:value-of select="$Minutes_modified"/>
				<xsl:text> *** </xsl:text>
				<xsl:text> decimal_val </xsl:text>
				<xsl:value-of select="$decimal_val"/>
				<xsl:text> *** </xsl:text>
				<xsl:text> decimals_var </xsl:text>
				<xsl:value-of select="$decimals_var"/>
				<xsl:text> *** </xsl:text>-->
				<xsl:choose>
					<xsl:when test="$Minutes_modified != ''">
						
						<!--<xsl:choose>
							<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=0">
								<xsl:choose>
									<!-\- If the string is  having hyphen symbol (-) symbol format it-\->
									<xsl:when test="contains($Coordinate,'-')">
										<xsl:value-of select="substring-before(substring-after($Coordinate,'-'),'.')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>00</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								
							</xsl:when>
							<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=1">
								<xsl:value-of select="concat('0',substring-before($Minutes_modified,$Separator))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-before($Minutes_modified,$Separator)"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>'.</xsl:text>-->
						<!--<xsl:text> $$Coordinate </xsl:text>
						<xsl:value-of select="$Coordinate"/>
						<xsl:text> #### </xsl:text>-->
						<xsl:choose>
							<!-- If the string is  having hyphen symbol (-) symbol format it-->
							<xsl:when test="contains($Coordinate,'-')">
								
								<xsl:variable name="decimals">
									<xsl:value-of select="substring-after(normalize-space($Coordinate),'.')"/>
								</xsl:variable>
								<xsl:value-of select="substring(substring($decimals,1,(string-length(normalize-space($decimals))-1)),1,$Precision)"/>
							</xsl:when>
							<xsl:otherwise>
								<!--<xsl:text> $Minutes_modified </xsl:text>
								<xsl:value-of select="$Minutes_modified"/>
								<xsl:text> **** </xsl:text>-->
								<!--<xsl:text> $decimals_var </xsl:text>
								<xsl:value-of select="$decimals_var"/>
								<xsl:text> #### </xsl:text>-->
								<!--<xsl:variable name="decimals_var">
								<xsl:value-of select="substring(substring-after($Minutes_modified,$Separator),1,$Precision+1)"/>
								</xsl:variable>-->
								
								<!--<xsl:value-of select="string-length($decimals_var)"/>
								<xsl:text> $$$ </xsl:text>-->
								<!--<xsl:variable name="extra_val">
								<xsl:value-of select="substring($decimals_var,string-length($decimals_var),1)"/>
								</xsl:variable>-->
								<!--<xsl:text> $$$ </xsl:text>-->
								<!--<xsl:text> $decimals_var :: </xsl:text>
								<xsl:value-of select="$decimals_var"/>
								<xsl:text> $$$ </xsl:text>
								<xsl:text> $Precision :: </xsl:text>
								<xsl:value-of select="$Precision"/>
								<xsl:text> $$$ </xsl:text>-->
								<!--<xsl:text> diference :: </xsl:text>
								<xsl:value-of select="$Precision - string-length($decimals_var)"/>
								<xsl:text> $$$ </xsl:text>-->
								
								<!--<xsl:choose>
									<xsl:when test="string-length($decimals_var) = $Precision">
										<xsl:value-of select="$decimals_var"/>
									</xsl:when>
									<xsl:when test="$Precision - string-length($decimals_var) = 1">
										<xsl:value-of select="concat($decimals_var,'0')"/>
									</xsl:when>
									<xsl:when test="$Precision - string-length($decimals_var) = 2">
										<xsl:value-of select="concat($decimals_var,'00')"/>
									</xsl:when>
									<xsl:otherwise>
										
								<xsl:choose>
									<xsl:when test="starts-with($decimals_var,'000')">
										<xsl:choose>
											<xsl:when test="$extra_val &gt;= 5">
												
												<xsl:variable name="value">
													<xsl:value-of select="(substring($decimals_var,1,string-length($decimals_var)-1))+1"/>
													
												</xsl:variable>
												<xsl:choose>
													<xsl:when test="string-length($value) = $Precision ">
														<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
													</xsl:when>
													<xsl:when test="$Precision - string-length($value) = 1">
														<xsl:value-of select="substring(concat('0',$value,'000'),1,$Precision)"/>
													</xsl:when>
													<xsl:when test="$Precision - string-length($value) = 2">
														<xsl:value-of select="substring(concat('00',$value,'000'),1,$Precision)"/>
													</xsl:when>
												</xsl:choose>
												
												<!-\-<xsl:value-of select="substring(concat('000',$value,'000'),1,$Precision)"/>-\->
											</xsl:when>
											
											
											
											<xsl:otherwise>
												
												<xsl:variable name="value">
													<xsl:value-of select="substring($decimals_var,1,string-length($decimals_var))"/>
												</xsl:variable>
												<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									
									<xsl:when test="starts-with($decimals_var,'00')">
										<xsl:choose>
											<xsl:when test="$extra_val &gt;= 5">
												
												<xsl:variable name="value">
													<xsl:value-of select="(substring($decimals_var,1,string-length($decimals_var)-1))+1"/>
												</xsl:variable>
												<xsl:choose>
													<xsl:when test="string-length($value) = $Precision ">
														<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
													</xsl:when>
													<xsl:when test="$Precision - string-length($value) = 1">
														<xsl:value-of select="substring(concat('0',$value,'000'),1,$Precision)"/>
													</xsl:when>
													<xsl:when test="$Precision - string-length($value) = 2">
														<xsl:value-of select="substring(concat('00',$value,'000'),1,$Precision)"/>
													</xsl:when>
												</xsl:choose>
												<!-\-<xsl:value-of select="substring(concat('00',$value,'000'),1,$Precision)"/>-\->
											</xsl:when>
											<xsl:otherwise>
												
												<xsl:variable name="value">
													<xsl:value-of select="substring($decimals_var,1,string-length($decimals_var))"/>
												</xsl:variable>
												<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="starts-with($decimals_var,'0')">
										<xsl:choose>
											<xsl:when test="$extra_val &gt;= 5">
												<!-\-<xsl:text> in single zero </xsl:text>
												<xsl:value-of select="$decimals_var"></xsl:value-of>
												<xsl:text> *** </xsl:text>-\->
												<xsl:variable name="value">
												<xsl:value-of select="(substring($decimals_var,1,string-length($decimals_var)-1))+1"/>
												</xsl:variable>
												<!-\-<xsl:text> value </xsl:text>
												<xsl:value-of select="$value"></xsl:value-of>
												<xsl:text> *** </xsl:text>-\->
												<xsl:choose>
													<xsl:when test="string-length($value) = $Precision ">
														<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
													</xsl:when>
													<xsl:when test="$Precision - string-length($value) = 1">
														<xsl:value-of select="substring(concat('0',$value,'000'),1,$Precision)"/>
													</xsl:when>
													<xsl:when test="$Precision - string-length($value) = 2">
														<xsl:value-of select="substring(concat('00',$value,'000'),1,$Precision)"/>
													</xsl:when>
												</xsl:choose>
												<!-\-<xsl:value-of select="substring(concat('0',$value,'000'),1,$Precision)"/>-\->
											</xsl:when>
											<xsl:otherwise>
												<!-\-<xsl:text> in single zero </xsl:text>
												<xsl:value-of select="$decimals_var"></xsl:value-of>
												<xsl:text> *** </xsl:text>-\->
												<xsl:variable name="value">
												<xsl:value-of select="substring($decimals_var,1,string-length($decimals_var))"/>
												</xsl:variable>
												
												<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<!-\-<xsl:text> decimal_val2 </xsl:text>
										<xsl:value-of select="$decimal_val"/>
										<xsl:text> *** </xsl:text>
										<xsl:text> $extra_val </xsl:text>
										<xsl:value-of select="$extra_val"/>
										<xsl:text> ^^^^ </xsl:text>-\->
								<xsl:choose>
									
									<xsl:when test="$extra_val &gt;= 5">
										
										<xsl:variable name="value">
										<xsl:value-of select="$decimal_val+1"/>
										</xsl:variable>
										<!-\-<xsl:value-of select="substring(concat(substring-after($Minutes_modified,$Separator),'000'),1,$Precision)"/>-\->
										<!-\-<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>-\->
										<!-\-<xsl:text> $decimals_var </xsl:text>
										<xsl:value-of select="$decimals_var"/>
										<xsl:text> *** </xsl:text>
										<xsl:text> decimal_val </xsl:text>
										<xsl:value-of select="$decimal_val"/>
										<xsl:text> *** </xsl:text>
										<xsl:text> value </xsl:text>
										<xsl:value-of select="$value"/>
										<xsl:text> *** </xsl:text>
										
										<xsl:text> final-result </xsl:text>
										<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
										<xsl:text> *** </xsl:text>-\->
										
										<xsl:choose>
											<xsl:when test="$decimal_val = 99 or $decimal_val = 999" >
												<xsl:choose>
													<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=0">
														<xsl:choose>
															<!-\- If the string is  having hyphen symbol (-) symbol format it-\->
															<xsl:when test="contains($Coordinate,'-')">
																<xsl:value-of select="substring-before(substring-after($Coordinate,'-'),'.')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>00</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
														
													</xsl:when>
													<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=1">
														<xsl:value-of select="concat('0',substring-before($Minutes_modified,$Separator))+1"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring-before($Minutes_modified,$Separator)+1"/>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:text>'.</xsl:text>
												<xsl:variable name="val" select="00"/>
												<xsl:value-of select="substring(concat('000',$val,'000'),1,$Precision)"/>
											</xsl:when>
											<xsl:otherwise>
												<!-\-<xsl:choose>
													<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=0">
														<xsl:choose>
															 <!-\\-If the string is  having hyphen symbol (-) symbol format it-\\->
															<xsl:when test="contains($Coordinate,'-')">
																<xsl:value-of select="substring-before(substring-after($Coordinate,'-'),'.')"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:text>00</xsl:text>
															</xsl:otherwise>
														</xsl:choose>
														
													</xsl:when>
													<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=1">
														<xsl:value-of select="concat('0',substring-before($Minutes_modified,$Separator))"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="substring-before($Minutes_modified,$Separator)"/>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:text>'.</xsl:text>
								<!-\\-<xsl:value-of select="substring(concat(substring-after($Minutes_modified,$Separator),'000'),1,$Precision)"/>-\\->-\->
										<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
										<xsl:when test="$decimal_val = 99 or $decimal_val = 999">
											<xsl:choose>
												<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=0">
													<xsl:choose>
														<!-\- If the string is  having hyphen symbol (-) symbol format it-\->
														<xsl:when test="contains($Coordinate,'-')">
															<xsl:value-of select="substring-before(substring-after($Coordinate,'-'),'.')"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>00</xsl:text>
														</xsl:otherwise>
													</xsl:choose>
													
												</xsl:when>
												<xsl:when test="string-length(substring-before($Minutes_modified,$Separator))=1">
													<xsl:value-of select="concat('0',substring-before($Minutes_modified,$Separator))+1"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="substring-before($Minutes_modified,$Separator)+1"/>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:text>'.</xsl:text>
											<xsl:variable name="value">
												<xsl:value-of select="substring($decimals_var,1,string-length($decimals_var))"/>
											</xsl:variable>
											<!-\-<xsl:text> value </xsl:text>
										<xsl:value-of select="$value"/>
										<xsl:text> *** </xsl:text>-\->
											<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
										</xsl:when>
										<xsl:otherwise>
										<xsl:variable name="value">
										<xsl:value-of select="substring($decimals_var,1,string-length($decimals_var))"/>
										</xsl:variable>
										<!-\-<xsl:text> value </xsl:text>
										<xsl:value-of select="$value"/>
										<xsl:text> *** </xsl:text>-\->
										<xsl:value-of select="substring(concat($value,'000'),1,$Precision)"/>
										</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>-->
								
								<!--<xsl:text> %%%% </xsl:text>-->
								<!--<xsl:value-of select="$decimals_var"/>-->
								<!--<xsl:text> $decimals_var </xsl:text>
								<xsl:value-of select="$decimals_var"/>
								<xsl:text> @@@ </xsl:text>-->
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$Precision =2">
								<xsl:text>00'.00</xsl:text>
							</xsl:when>
							<xsl:when test="$Precision =3">
								<xsl:text>00'.000</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:value-of select="concat($Quadrant,'.')"/>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="MISC_SECTION_CATALOGUE"/>

	<xsl:template name="split">
		<xsl:param name="notice"/>
		<xsl:param name="string"/>
		<xsl:if test="substring-after($string,',')!=''">
			<item>
				<xsl:attribute name="notice">
					<xsl:value-of select="normalize-space($notice)"/>
				</xsl:attribute>
				<xsl:attribute name="chart">
				<!--	<xsl:if test="not(contains($string,'NZ'))">
						<xsl:text>NZ </xsl:text>
					</xsl:if>-->
					<xsl:value-of select="normalize-space(substring-before($string,','))"/>
				</xsl:attribute>
			</item>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="substring-after($string,',')!=''">
				<xsl:call-template name="split">
					<xsl:with-param name="notice" select="normalize-space($notice)"/>
					<xsl:with-param name="string" select="normalize-space(substring-after($string,','))"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(contains($string,','))">
				<item>
					<xsl:attribute name="notice">
						<xsl:value-of select="normalize-space($notice)"/>
					</xsl:attribute>
					<xsl:attribute name="chart">
						<!--<xsl:if test="not(contains($string,'NZ'))">
							<xsl:text>NZ </xsl:text>
						</xsl:if>-->
						<xsl:value-of select="normalize-space($string)"/>
					</xsl:attribute>
				</item>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sub-class">
		<xsl:param name="result"/>
		<xsl:for-each select="$result/item[count(. | key('item', @chart)[1]) = 1]">
			<xsl:sort select="substring-before(concat(translate(normalize-space(translate(@chart,'NZ','')),' ','-'),'-'),'-')" data-type="number" order="ascending"/>
			<tr>
				<td style="border-right: 1px solid;">
					<xsl:value-of select="@chart"/>
				</td>
				<td>
					<xsl:for-each select="key('item', @chart)">
						<xsl:sort select="substring-before(concat(@notice,'('),'(')" data-type="number" order="ascending"/>
						<xsl:variable name="pos" select="position()"/>
						<xsl:if test="$pos!=1">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:value-of select="@notice"/>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="delimit">
		<xsl:for-each select="//CHART_NUM[ancestor::NM_MISC_INSTRUCT_PNCNCP or ancestor::NM_MISC_INSTRUCT_PNCNEP or ancestor::NM_MISC_INSTRUCT_ENC or ancestor::NM_PNC_PRD_TPUB]">
			<xsl:sort select="normalize-space(translate(.,'NZ',''))" order="ascending" data-type="number"/>
			<xsl:choose>
				<xsl:when test="position()=1">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(',',.)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:text>,</xsl:text>
		<xsl:for-each select="//ENC_NAME[ancestor::NM_ENC_PRD]">
			<xsl:sort select="normalize-space(translate(.,'NZ',''))" order="ascending" data-type="number"/>
			<xsl:choose>
				<xsl:when test="position()=1">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(',',.)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="distinct-values">
		<xsl:param name="delimit-values"/>
		
		<xsl:variable name="first-value">
			<xsl:value-of select="substring-before($delimit-values,',')"/>
		</xsl:variable>
		
		<xsl:variable name="rest-values">
			<xsl:value-of select="substring-after($delimit-values,',')"/>
		</xsl:variable>
		
		<xsl:if test="not(contains($rest-values, concat($first-value,',')))">
			<tr>
				<td >
					<xsl:if test="not(contains($first-value,'NZ')) and normalize-space($first-value)">
						<!--<xsl:text>NZ </xsl:text>-->
						
					</xsl:if>
					<xsl:value-of select="$first-value"/>
				</td>
			</tr>
		</xsl:if>

		<xsl:if test="normalize-space($rest-values)">		
			<xsl:call-template name="distinct-values">
				<xsl:with-param name="delimit-values" select="$rest-values"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="distinct-charts">
		<xsl:param name="delimit-charts"/>

		<xsl:variable name="first-value">
			<xsl:choose>
				<xsl:when test="not(contains($delimit-charts,','))">
					<xsl:value-of select="$delimit-charts"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before($delimit-charts,',')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:variable name="rest-values">
			<xsl:value-of select="substring-after($delimit-charts,',')"/>
		</xsl:variable>
		
		<xsl:if test="not(contains($rest-values, concat($first-value,',')))">
			<!--<xsl:if test="not(contains($first-value,'NZ'))">
				<xsl:text>NZ </xsl:text>
			</xsl:if>-->
			<xsl:choose>
				<xsl:when test="normalize-space($rest-values)">
					<xsl:value-of select="concat($first-value,',')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$first-value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		<xsl:if test="normalize-space($rest-values)">		
			<xsl:call-template name="distinct-charts">
				<xsl:with-param name="delimit-charts" select="$rest-values"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="NM_TORP_INSTRUCTION">
		<li style="margin-bottom:9pt;margin-top:15pt">
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="NM_TORP_LIST">
		<ol style="list-style-type:lower-alpha;">
			<xsl:choose>
			<xsl:when test=".//BR">
				<xsl:for-each select=".//text()">
					<li>
						<xsl:copy-of select="."/>
					</li>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
					<xsl:apply-templates mode="torp"/>
			</xsl:otherwise>
		</xsl:choose>
		</ol>
	</xsl:template>

	<xsl:template match="NM_TORP_TABLE">
		<xsl:if test="normalize-space(NM_TORP_TABLE_LIST/NM_TORPCOLUMN_DATA)">
		<!--<div style="margin-left:10pt;">-->
		<table>
			<tr>
				<xsl:apply-templates select="NM_TORP_TABLE_LIST/NM_TORPCOLUMN_DATA"/>
			</tr>
		</table>
		<!--</div>-->
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="SPAN" mode="torp">
		<xsl:apply-templates mode="torp"/>
	</xsl:template>
	
	<xsl:template match="P" mode="torp">
		<li style="margin-bottom:10pt">
		<xsl:apply-templates mode="torp"/>
		</li>
	</xsl:template>
	
	<xsl:template match="NM_TORPCOLUMN_DATA">
<!--		<xsl:if test="position()=1">
			<td>
				<xsl:value-of select="../NM_TORP_LABEL"/>
			</td>
		</xsl:if>
-->		<xsl:choose>
			<xsl:when test=".//BR">
			
		<td style="padding-left:5px;">
			<xsl:choose>
				<xsl:when test="position()=1">
						<xsl:if test=".//BR">
							<xsl:if test="normalize-space(../NM_TORP_LABEL)">
								<xsl:value-of select="''"/>
								<br/>
							</xsl:if>
								<xsl:value-of select="''"/>
								<br/>
							<xsl:for-each select=".//text()">
								<xsl:variable name="pos" select="position()"/>
								<i>
								<!--<xsl:value-of select="normalize-space(concat('(',msxsl:node-set($lower-alpha)/list-values/item[@num=$pos],') '))"/>-->
								</i>
								<br/>
							</xsl:for-each>
						</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test=".//BR">
						<xsl:if test="normalize-space(../NM_TORP_LABEL)">
							<i><xsl:value-of select="../NM_TORP_LABEL"/></i>
							<br/>
						</xsl:if>
						<xsl:if test="normalize-space(../NM_TANDP_TITLE) != ''">
						<xsl:value-of select="../NM_TANDP_TITLE"/>
						<br/>
						</xsl:if>
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</td>
			
		<td style="padding-left:5px;">
			<xsl:if test="position()=1">
				<xsl:if test="normalize-space(../NM_TORP_LABEL)">
				<i>
				<xsl:value-of select="../NM_TORP_LABEL"/>
				</i>
				<br/>
				</xsl:if>
				<xsl:if test="normalize-space(../NM_TANDP_TITLE) != ''">
				<xsl:value-of select="../NM_TANDP_TITLE"/>
				<br/>
				</xsl:if>
				<xsl:if test=".//BR">
					<xsl:copy-of select="."/>
				</xsl:if>
		</xsl:if>
		</td>
			</xsl:when>
			
			<xsl:otherwise>
				<td>
				<table>
					<tr>
				<td style="padding-left:10px;">
					<i><xsl:value-of select="../NM_TORP_LABEL"/></i>
				</td></tr>
					<xsl:if test=".">
					</xsl:if>
					<xsl:if test="../NM_TANDP_TITLE != ''">
					<tr>
						<td style="padding-left:10px;">
							<xsl:value-of select="../NM_TANDP_TITLE"/>
						</td>
						
					</tr>
					</xsl:if>
					<tr>
						<td style="padding-left:10px;">
							<xsl:value-of select="."/>
				</td>
				</tr>
				</table>
				</td>
			</xsl:otherwise>			
		</xsl:choose>
	</xsl:template>
	
	<!--================================================================================== -->
	<!-- Generic HTML element templates  -->
	<!--================================================================================== -->
	<xsl:template match="BR">
	<!--	<xsl:if test="not(parent::NM_CONTENT)">-->
			<br/>
		<!--</xsl:if>-->
	</xsl:template>
	
	<xsl:template match="STRONG">
		<B>
			<xsl:apply-templates/>
		</B>
	</xsl:template>
	
	<xsl:template match="I | EM">
		<I>
			<xsl:apply-templates/>
		</I>
	</xsl:template>
	
	<xsl:template match="FONT">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="A">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="@href"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	
	<xsl:template match="P" mode="html">
		<p style="margin-left:.2in;"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="BR" mode="html">
		<br/>
	</xsl:template>
	
	<xsl:template match="sup" mode="html">
		<sup>
			<xsl:value-of select="."/>
		</sup>
	</xsl:template>
	<xsl:template name="last-index-of">
		<xsl:param name="txt"/>
		<xsl:param name="remainder" select="$txt"/>
		<xsl:param name="delimiter" select="'\'"/>
		
		<xsl:choose>
			<xsl:when test="contains($remainder, $delimiter)">
				<xsl:call-template name="last-index-of">
					<xsl:with-param name="txt" select="$txt"/>
					<xsl:with-param name="remainder" select="substring-after($remainder, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>      
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="lastIndex" select="string-length(substring($txt, 1, string-length($txt)-string-length($remainder)))+1"/>
				<xsl:choose>
					<xsl:when test="string-length($remainder)=0">
						<xsl:value-of select="string-length($txt)"/>
					</xsl:when>
					<xsl:when test="$lastIndex>0">
						<xsl:value-of select="($lastIndex - string-length($delimiter))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="0"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- for the LAST_CORRECTION date format -->
	<xsl:template name="lastdateformat">
		<xsl:param name="datestr" />
		<!-- input format yyyynnn -->
		<!-- output format nnn/yy -->
		
		<xsl:variable name="yy">
			<xsl:value-of select="substring($datestr,3,2)" />
		</xsl:variable>
		
		<xsl:variable name="nn">
			<xsl:value-of select="substring($datestr,5,3)" />
		</xsl:variable>
		
		<xsl:value-of select="$nn" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="$yy" />
	</xsl:template>
	<!-- for EDITION_DATE format -->
	<xsl:template name="editiondateformat">
		<xsl:param name="datestr" />
		<!-- input format yyyymmdd -->
		<!-- output format june yy -->
		<xsl:variable name="mm">
			<xsl:value-of select="substring($datestr,5,2)" />
		</xsl:variable>
		<xsl:variable name="yy">
			<xsl:value-of select="substring($datestr,3,2)" />
		</xsl:variable>
		<xsl:text>NE </xsl:text>
		<xsl:choose>
			<xsl:when test="$mm = '01'"> Jan </xsl:when>
			<xsl:when test="$mm = '02'"> Feb </xsl:when>
			<xsl:when test="$mm = '03'"> Mar </xsl:when>
			<xsl:when test="$mm = '04'"> April </xsl:when>
			<xsl:when test="$mm = '05'"> May </xsl:when>
			<xsl:when test="$mm = '06'"> Jun </xsl:when>
			<xsl:when test="$mm = '07'"> Jul </xsl:when>
			<xsl:when test="$mm = '08'"> Aug </xsl:when>
			<xsl:when test="$mm = '09'"> Sept </xsl:when>
			<xsl:when test="$mm = '10'"> Oct </xsl:when>
			<xsl:when test="$mm = '11'"> Nov </xsl:when>
			<xsl:when test="$mm = '12'"> Dec </xsl:when>
		</xsl:choose>
		
		<xsl:text> </xsl:text>
		<xsl:value-of select="$yy" />
	</xsl:template>
	<!-- for DATE format -->
	<xsl:template name="format">
		<xsl:param name="datestr" />
		<!-- input format yyyymmdd -->
		<!-- output format june yy -->
		<xsl:variable name="mm">
			<xsl:value-of select="substring($datestr,5,2)" />
		</xsl:variable>
		<xsl:variable name="yy">
			<xsl:value-of select="substring($datestr,1,4)" />
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$mm = '01'"> January </xsl:when>
			<xsl:when test="$mm = '02'"> February </xsl:when>
			<xsl:when test="$mm = '03'"> March </xsl:when>
			<xsl:when test="$mm = '04'"> April </xsl:when>
			<xsl:when test="$mm = '05'"> May </xsl:when>
			<xsl:when test="$mm = '06'"> June </xsl:when>
			<xsl:when test="$mm = '07'"> July </xsl:when>
			<xsl:when test="$mm = '08'"> August </xsl:when>
			<xsl:when test="$mm = '09'"> September </xsl:when>
			<xsl:when test="$mm = '10'"> October </xsl:when>
			<xsl:when test="$mm = '11'"> November </xsl:when>
			<xsl:when test="$mm = '12'"> December </xsl:when>
		</xsl:choose>
		
		<xsl:text> </xsl:text>
		<xsl:value-of select="$yy" />
	</xsl:template>
	<!--================================================================================== -->
	<!--                         END OF THE XSLT SCRIPT                                    -->
	<!--================================================================================== -->
</xsl:stylesheet>
