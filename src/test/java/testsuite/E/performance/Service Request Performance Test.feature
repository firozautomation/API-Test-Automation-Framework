#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Service Performance Test

   Background:

    #DO NOT MODIFY UNLESS YOUR BRAVE AND YOU KNOW WHAT YOUR DOING*******************************************************
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * def setup = callonce read('classpath:reusable/Generate-Token.feature')
    * def Token = setup.token
    * def env = setup.Environment
    * def ch = setup.Channel
    * assert JavaMethods.socks5BypassConfig() == true
    * call JavaMethods.connectToMongo(env,ch)
    * call JavaMethods.connectSQL(env,ch)
    
    * url 'http://' + env + '-' + ch + '-shared-services-service-request-service.' + env + '.cloud.ds.gehc.net/serviceRequest/v1/'
    
   		#Retrieves most mandatory values for Service Request GET method from existing payload(s)
	    * def retrieve = callonce read('classpath:reusable/Retrieve-SR-Mandatory-Fields.feature')
	    * def srId = retrieve.fsrId
	    * def taskId = retrieve.ftaskId
	    * def serviceRequestCode = retrieve.fserviceRequestCode
	    * def sourceSystemCode = retrieve.fsourceSystemCode
	    * def taskCode = retrieve.ftaskCode
	    #* def assetId = retrieve.fassetId
	    * def assetTblAssetId = retrieve.fassetTblAssetId
	    * def country = retrieve.fcountry
	    * def staticRand = JavaMethods.generateRandomNumber()
	    
	    
    #*******************************************************************************************************************

    
    
	Scenario: Insert X valid Records into Service Request Service Post Method
   	* call JavaMethods.setGlobalPerformanceTestData(serviceRequestCode,sourceSystemCode,taskCode,assetTblAssetId,country)

	* def ServiceRequestPerformanceTemplate = JavaMethods.createTestData('Service Request: Insert', 100, staticRand, 0, 0)

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPerformanceTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request Performance', loadUID, 'INSERTED') == true	
  	
  	
  	#Maint DB Check Point
  	#* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'PerformanceTestUsingKarate%\' AND Requester = \'' + staticRand + '\';'
  	#* assert JavaMethods.executeSQLQuery(sqlQuery, 100) == true 