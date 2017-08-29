<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright (C) 2013 Peter Schober <peter@aco.net>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as
  published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata"
                xmlns:mdui="urn:oasis:names:tc:SAML:metadata:ui"
                xmlns:mdrpi="urn:oasis:names:tc:SAML:metadata:rpi"
                xmlns:shibmd="urn:mace:shibboleth:metadata:1.0"
                xmlns:mdattr="urn:oasis:names:tc:SAML:metadata:attribute"
                xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
                xmlns:alg="urn:oasis:names:tc:SAML:metadata:algsupport"
                xmlns:init="urn:oasis:names:tc:SAML:profiles:SSO:request-init"
                exclude-result-prefixes="md mdui mdrpi shibmd mdattr saml alg init">
  <xsl:output method="html" omit-xml-declaration="yes" indent="yes" encoding="iso-8859-1"/>
  <xsl:include href="url-encode.xsl"/>
  <xsl:template match="/md:EntitiesDescriptor">
    <html>
      <head>
        <title>SP</title>
        <script type="text/javascript" src="js/jquery-latest.js"></script>
        <script type="text/javascript" src="js/jquery.metadata.js"></script>
        <script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
        <script type="text/javascript" src="js/script.js"></script>
        <link rel="stylesheet" href="themes/blue/style.css" />
      </head>
      <body>
        <table id="datatable" border="1" cellpadding="5" cellspacing="0" class="tablesorter">
          <thead>
            <tr class="eduid_head">
              <th>Service</th>
              <th>Beschreibung</th>
              <th>Attribute</th>
              <th>Organisation</th>
              <th>SAML Entity</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="md:EntityDescriptor[md:SPSSODescriptor]"/>
          </tbody>
          <tfoot>
            <tr class="eduid_head">
              <th>Service</th>
              <th>Beschreibung</th>
              <th>Attribute</th>
              <th>Organisation</th>
              <th>SAML Entity</th>
            </tr>
          </tfoot>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="md:EntityDescriptor">
    <!-- Try hard to find a Name -->
    <xsl:variable name="mduiName.de">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:DisplayName[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="mduiName.en">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:DisplayName[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="mduiName.any">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:DisplayName[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="srvName.de">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceName[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="srvName.en">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceName[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="srvName.any">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceName[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="Name">
      <xsl:choose>
        <xsl:when test="string-length($mduiName.de) &gt; 0">
          <xsl:value-of select="$mduiName.de"/>
        </xsl:when>
        <xsl:when test="string-length($mduiName.en) &gt; 0">
          <xsl:value-of select="$mduiName.en"/>
        </xsl:when>
        <xsl:when test="string-length($srvName.de) &gt; 0">
          <xsl:value-of select="$srvName.de"/>
        </xsl:when>
        <xsl:when test="string-length($srvName.en) &gt; 0">
          <xsl:value-of select="$srvName.en"/>
        </xsl:when>
        <xsl:when test="string-length($mduiName.any) &gt; 0">
          <xsl:value-of select="$mduiName.any"/>
        </xsl:when>
        <xsl:when test="string-length($srvName.any) &gt; 0">
          <xsl:value-of select="$srvName.any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find a Description -->
    <xsl:variable name="mduiDesc.de">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Description[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="mduiDesc.en">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Description[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="mduiDesc.any">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Description[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="srvDesc.de">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceDescription[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="srvDesc.en">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceDescription[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="srvDesc.any">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceDescription[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="Desc">
      <xsl:choose>
        <xsl:when test="string-length($mduiDesc.de) &gt; 0">
          <xsl:value-of select="$mduiDesc.de"/>
        </xsl:when>
        <xsl:when test="string-length($mduiDesc.en) &gt; 0">
          <xsl:value-of select="$mduiDesc.en"/>
        </xsl:when>
        <xsl:when test="string-length($srvDesc.de) &gt; 0">
          <xsl:value-of select="$srvDesc.de"/>
        </xsl:when>
        <xsl:when test="string-length($srvDesc.en) &gt; 0">
          <xsl:value-of select="$srvDesc.en"/>
        </xsl:when>
        <xsl:when test="string-length($mduiDesc.any) &gt; 0">
          <xsl:value-of select="$mduiDesc.any"/>
        </xsl:when>
        <xsl:when test="string-length($srvDesc.any) &gt; 0">
          <xsl:value-of select="$srvDesc.any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find an Info URL -->
    <xsl:variable name="mduiURL.de">
      <xsl:value-of select="md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:InformationURL[@xml:lang='de']"/>
    </xsl:variable>
    <xsl:variable name="mduiURL.en">
      <xsl:value-of select="md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:InformationURL[@xml:lang='en']"/>
    </xsl:variable>
    <xsl:variable name="mduiURL.any">
      <xsl:value-of select="md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:InformationURL[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1]"/>
    </xsl:variable>
    <xsl:variable name="mduiURL">
      <xsl:choose>
        <xsl:when test="string-length($mduiURL.de) &gt; 0">
          <xsl:value-of select="$mduiURL.de"/>
        </xsl:when>
        <xsl:when test="string-length($mduiURL.en) &gt; 0">
          <xsl:value-of select="$mduiURL.en"/>
        </xsl:when>
        <xsl:when test="string-length($mduiURL.any) &gt; 0">
          <xsl:value-of select="$mduiURL.any"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find an Org Name -->
    <xsl:variable name="orgName.de">
      <xsl:value-of select="normalize-space(md:Organization/md:OrganizationDisplayName[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="orgName.en">
      <xsl:value-of select="normalize-space(md:Organization/md:OrganizationDisplayName[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="orgName.any">
      <xsl:value-of select="normalize-space(md:Organization/md:OrganizationDisplayName[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="orgName">
      <xsl:choose>
        <xsl:when test="string-length($orgName.de) &gt; 0">
          <xsl:value-of select="$orgName.de"/>
        </xsl:when>
        <xsl:when test="string-length($orgName.en) &gt; 0">
          <xsl:value-of select="$orgName.en"/>
        </xsl:when>
        <xsl:when test="string-length($orgName.any) &gt; 0">
          <xsl:value-of select="$orgName.any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find an Org URL -->
    <xsl:variable name="orgURL.de">
      <xsl:value-of select="md:Organization/md:OrganizationURL[@xml:lang='de']"/>
    </xsl:variable>
    <xsl:variable name="orgURL.en">
      <xsl:value-of select="md:Organization/md:OrganizationURL[@xml:lang='en']"/>
    </xsl:variable>
    <xsl:variable name="orgURL.any">
      <xsl:value-of select="md:Organization/md:OrganizationURL[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1]"/>
    </xsl:variable>
    <xsl:variable name="orgURL">
      <xsl:choose>
        <xsl:when test="string-length($orgURL.de) &gt; 0">
          <xsl:value-of select="$orgURL.de"/>
        </xsl:when>
        <xsl:when test="string-length($orgURL.en) &gt; 0">
          <xsl:value-of select="$orgURL.en"/>
        </xsl:when>
        <xsl:when test="string-length($orgURL.any) &gt; 0">
          <xsl:value-of select="$orgURL.any"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="regAuth">
      <xsl:value-of select="md:Extensions/mdrpi:RegistrationInfo/@registrationAuthority"/>
    </xsl:variable>

    <tr>

      <!-- Service name + URL -->
      <td valign="top">
        <xsl:choose>
          <xsl:when test="$mduiURL and contains($mduiURL, '://')">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$mduiURL"/>
              </xsl:attribute>
              <xsl:value-of select="$Name"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$Name"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Service description -->
      <td valign="top">
        <xsl:value-of select="$Desc"/>
      </td>

      <!-- Requested Attrs -->
      <td valign="top">
        <table>
          <xsl:if test="md:Extensions/mdattr:EntityAttributes/saml:Attribute[@Name='http://macedir.org/entity-category']">
            <tr>
              <td>EntityCat</td>
            </tr>
          </xsl:if>
          <xsl:if test="md:Extensions/alg:DigestMethod or md:Extensions/alg:SigningMethod">
            <tr>
              <td>Algorithms</td>
            </tr>
          </xsl:if>
          <xsl:if test="*/md:SingleLogoutService">
            <tr>
              <td>SLO</td>
            </tr>
          </xsl:if>
          <xsl:if test="md:SPSSODescriptor/md:Extensions/init:RequestInitiator">
            <tr>
              <td>RIP</td>
            </tr>
          </xsl:if>
        </table>
      </td>

      <!-- Organization + URL -->
      <td valign="top">
        <xsl:choose>
          <xsl:when test="$orgURL and contains($orgURL, '://')">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$orgURL"/>
              </xsl:attribute>
              <xsl:value-of select="$orgName"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$orgName"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Entity 
        The file name is derived from the URL with by replacing '/' with '_' and ':' with '.'.
      -->
      <td valign="top">
        <xsl:variable name="filename">
          <xsl:value-of select="translate(translate(@entityID, ':', '.'), '/', '_')"/>
        </xsl:variable>
        <xsl:variable name="encodedFilename">
          <xsl:call-template name="url-encode">
            <xsl:with-param name="str" select="$filename"/>
          </xsl:call-template>
        </xsl:variable>
        <a href="entities/{$encodedFilename}.xml">
          <xsl:value-of select="@entityID"/>
        </a>
      </td>

    </tr>
  </xsl:template>

  <xsl:template match="md:ContactPerson" name="ContactName">
    <xsl:apply-templates select="md:GivenName"/>
    <xsl:if test="md:GivenName">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="md:SurName"/>
  </xsl:template>

  <xsl:template match="md:EmailAddress">
    <xsl:choose>
      <xsl:when test="contains(text(),'mailto:')">
        <xsl:value-of select="normalize-space(substring-after(text(),'mailto:'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(text())"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="md:GivenName">
    <xsl:value-of select="normalize-space(text())"/>
  </xsl:template>

  <xsl:template match="md:SurName">
    <xsl:value-of select="normalize-space(text())"/>
  </xsl:template>

  <xsl:template match="md:SPSSODescriptor/md:Extensions/shibmd:Scope">
    <xsl:value-of select="normalize-space(text())"/>
  </xsl:template>

  <xsl:template name="Scopes">
    <xsl:for-each select="md:SPSSODescriptor/md:Extensions/shibmd:Scope">
      <li>
        <xsl:value-of select="normalize-space(text())"/>
      </li>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="Contacts">
    <xsl:for-each select="md:ContactPerson[@contactType='technical']">
      <li>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:apply-templates select="md:EmailAddress"/>
          </xsl:attribute>
          <xsl:call-template name="ContactName"/>
        </xsl:element>
      </li>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="md:RequestedAttribute">
    <tr>
      <xsl:choose>
        <xsl:when test="@isRequired = 'true'">
          <td align="right">
            <div>
              <span title="notwendig">
                <input type="checkbox" name="required" value="true" checked="checked" disabled="disabled"/>
              </span>
            </div>
          </td>
          <td class="notwendig">
            <xsl:choose>
              <xsl:when test="@FriendlyName">
                <xsl:element name="span">
                  <xsl:attribute name="title">
                    <xsl:value-of select="@Name"/>
                  </xsl:attribute>
                  <xsl:value-of select="@FriendlyName"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Name"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td align="right">
            <div>
              <span title="optional">
                <input type="checkbox" name="required" value="false" disabled="disabled"/>
              </span>
            </div>
          </td>
          <td class="optional">
            <xsl:choose>
              <xsl:when test="@FriendlyName">
                <xsl:element name="span">
                  <xsl:attribute name="title">
                    <xsl:value-of select="@Name"/>
                  </xsl:attribute>
                  <xsl:value-of select="@FriendlyName"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Name"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
  </xsl:template>

</xsl:stylesheet>