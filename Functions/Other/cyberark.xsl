<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="./Syslog/RFC5424Changes-toUTC.xsl"/>
<xsl:output method="text" version="1.0" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:apply-imports/>
        <xsl:for-each select="syslog/audit_record">
            <xsl:text>&lt;170&gt;1 </xsl:text><xsl:value-of select="IsoTimestamp"/><xsl:text> </xsl:text><xsl:value-of select="Hostname"/><xsl:text> LEEF:1.0</xsl:text>
            <xsl:text>|</xsl:text>
            <xsl:value-of select="Vendor"/>
            <xsl:text>|</xsl:text>
            <xsl:value-of select="Product"/>
            <xsl:text>|</xsl:text>
            <xsl:value-of select="Version"/>
            <xsl:text>|</xsl:text>
            <xsl:value-of select="MessageID"/>
            <xsl:text>|</xsl:text>
            <xsl:text>devtime=</xsl:text>        <xsl:value-of select="IsoTimestamp"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Hostname=</xsl:text>       <xsl:value-of select="Hostname"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>MessageID=</xsl:text>      <xsl:value-of select="MessageID"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Desc=</xsl:text>           <xsl:value-of select="Desc"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Severity=</xsl:text>       <xsl:value-of select="Severity"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Issuer=</xsl:text>         <xsl:value-of select="Issuer"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Action=</xsl:text>         <xsl:value-of select="Action"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>SourceUser=</xsl:text>     <xsl:value-of select="SourceUser"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>TargetUser=</xsl:text>     <xsl:value-of select="TargetUser"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Safe=</xsl:text>           <xsl:value-of select="Safe"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>File=</xsl:text>           <xsl:value-of select="File"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Station=</xsl:text>        <xsl:value-of select="Station"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Location=</xsl:text>       <xsl:value-of select="Location"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Category=</xsl:text>       <xsl:value-of select="Category"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>RequestId=</xsl:text>      <xsl:value-of select="RequestId"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Reason=</xsl:text>
                <xsl:call-template name="string-replace">
                    <xsl:with-param name="source"  select="Reason"/>
                    <xsl:with-param name="lookup"  select="'='"         />
                    <xsl:with-param name="rewrite" select="'\='"        />
                </xsl:call-template>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>RemoteMachine=</xsl:text>  <xsl:value-of select="PvwaDetails/RequestReason/ConnectionDetails/RemoteMachine"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>ExtraDetails=</xsl:text>
                <xsl:call-template name="string-replace">
                    <xsl:with-param name="source"  select="ExtraDetails"/>
                    <xsl:with-param name="lookup"  select="'='"         />
                    <xsl:with-param name="rewrite" select="'\='"        />
                </xsl:call-template>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>Message=</xsl:text>        <xsl:value-of select="Message"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>GatewayStation=</xsl:text> <xsl:value-of select="GatewayStation"/>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>CAPropertyAddress=</xsl:text>
            <xsl:for-each select="CAProperties/CAProperty">
                <xsl:if test="@Name='Address'">
                    <xsl:call-template name="string-replace">
                        <xsl:with-param name="source"  select="@Value" />
                        <xsl:with-param name="lookup"  select="'='"    />
                        <xsl:with-param name="rewrite" select="'/='"   />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>CAPropertyUserName=</xsl:text>
            <xsl:for-each select="CAProperties/CAProperty">
                <xsl:if test="@Name='UserName'">
                    <xsl:call-template name="string-replace">
                        <xsl:with-param name="source"  select="@Value" />
                        <xsl:with-param name="lookup"  select="'='"    />
                        <xsl:with-param name="rewrite" select="'/='"   />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>&#x9;</xsl:text>
            <xsl:text>CAPropertyDeviceType=</xsl:text>
            <xsl:for-each select="CAProperties/CAProperty">
                <xsl:if test="@Name='DeviceType'">
                    <xsl:call-template name="string-replace">
                        <xsl:with-param name="source"  select="@Value" />
                        <xsl:with-param name="lookup"  select="'='"    />
                        <xsl:with-param name="rewrite" select="'/='"   />
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>
    <!-- replace all occurences of the string 'lookup' by the string 'rewrite' in the string 'source' -->
    <xsl:template name="string-replace">
        <xsl:param name="source"/>
        <xsl:param name="lookup"/>
        <xsl:param name="rewrite"/>
        <xsl:choose>
            <xsl:when test="contains($source,$lookup)">
                <xsl:value-of select="translate(substring-before($source,$lookup),'&#xd;&#xa;&#xD;&#xA;','----')"/>
                <xsl:value-of select="$rewrite"/>
                <xsl:call-template name="string-replace">
                    <xsl:with-param name="source"  select="substring-after($source,$lookup)"/>
                    <xsl:with-param name="lookup"  select="$lookup"/>
                    <xsl:with-param name="rewrite" select="$rewrite"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate($source,'&#xd;&#xa;&#xD;&#xA;','----')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
