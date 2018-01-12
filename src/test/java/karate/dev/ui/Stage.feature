#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Service POST Smoke Test

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
	    
	    #Stuff from Java
	    * def NewServiceRequestCode = JavaMethods.generateRandomNumber()
	    * def NewTaskCode = JavaMethods.generateRandomNumber()
    #*******************************************************************************************************************

    
    
    
    Scenario: Submit a new Service Request POST:
   
   		* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   'Karate-Insert: UpdateAssetAvailability'  |
					|       assetAvailability   |            'Up'							  |


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request srId', loadUID, 'INSERTED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true