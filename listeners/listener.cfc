<cfcomponent>
	<cfset variables.instanceName = "">

	<cffunction name="init" access="public" returntype="listener">
		<cfargument name="instanceName" type="string" required="true">
		<cfset variables.instanceName = arguments.instanceName>
        <cfset serviceLoader = createObject("component", "bugLog.components.service").init( instanceName = variables.instanceName )/>
		<cfreturn this>
	</cffunction>

	<cffunction name="getCorsSettings" access="public" returntype="struct">
		<cfset var cors = StructNew()>
		<cfset var cors.enabled = serviceLoader.getConfig().getSetting("cors.enabled", false)/>

		<!--- A list of domains allowed to use this service.  You can use a wildcard or a list of domains --->
		<cfset var cors.allowOrigin = serviceLoader.getConfig().getSetting("cors.allowOrigin", "*")/>

		<!--- A list of accepted http methods; if a method used does not exist preflight will fail --->
		<cfset var cors.allowMethods = serviceLoader.getConfig().getSetting("cors.allowMethods", "GET, POST, OPTIONS, ACCEPT")/>

		<!--- A list of accepted http headers; if additional headers exist preflight will fail --->
		<cfset var cors.allowHeaders = serviceLoader.getConfig().getSetting("cors.allowHeaders", "Origin, Content-Type, Accept")/>

		<!--- If Allow Origin is '*' then Allow Credentials (allows cookies to be sent) must be false --->
		<cfset var cors.allowCredentials = serviceLoader.getConfig().getSetting("cors.allowCredentials", "false")/>

		<!--- Max Age controls how long (in seconds) before the client will send the OPTIONS preflight method --->
		<cfset var cors.maxAge = serviceLoader.getConfig().getSetting("cors.maxAge", "1728000")/>

		<cfreturn cors>
	</cffunction>

	<cffunction name="logEntry" access="public" returntype="void">
		<cfargument name="dateTime" type="Date" required="true">
		<cfargument name="message" type="string" required="true">
		<cfargument name="applicationCode" type="string" required="true">
		<cfargument name="severityCode" type="string" required="true">
		<cfargument name="hostName" type="string" required="true">
		<cfargument name="exceptionMessage" required="false" default="">
		<cfargument name="exceptionDetails" required="false" default="">
		<cfargument name="CFID" type="string" required="false" default="">
		<cfargument name="CFTOKEN" type="string" required="false" default="">
		<cfargument name="userAgent" type="string" required="false" default="">
		<cfargument name="templatePath" type="string" required="false" default="">
		<cfargument name="HTMLReport" type="string" required="false" default="">
		<cfargument name="APIKey" type="string" required="false" default="">
		<cfargument name="source" type="string" required="false" default="Unknown">
		<cfscript>
			// get handle to bugLogListener service
			var bugLogListener = serviceLoader.getService();

			// create entry bean
			var rawEntry = createObject("component","bugLog.components.rawEntryBean")
								.init()
								.setDateTime(arguments.dateTime)
								.setMessage(arguments.message)
								.setApplicationCode(arguments.applicationCode)
								.setSourceName(arguments.source)
								.setSeverityCode(arguments.severityCode)
								.setHostName(arguments.hostName)
								.setExceptionMessage(arguments.exceptionMessage)
								.setExceptionDetails(arguments.exceptionDetails)
								.setCFID(arguments.cfid)
								.setCFTOKEN(arguments.cftoken)
								.setUserAgent(arguments.userAgent)
								.setTemplatePath(arguments.templatePath)
								.setHTMLReport(arguments.HTMLReport)
								.setReceivedOn(now());

			// validate Entry
			bugLogListener.validate(rawEntry, arguments.APIKey);
						
			// log entry
			bugLogListener.logEntry(rawEntry);
		</cfscript>
	</cffunction>
	
</cfcomponent>