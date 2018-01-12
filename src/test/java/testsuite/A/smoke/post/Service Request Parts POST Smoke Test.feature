#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Parts POST Method Verification 

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
	    * def NewReference = JavaMethods.generateRandomNumber()
	    * def NewSourceId = JavaMethods.generateRandomNumber()	    
    #*******************************************************************************************************************

    
    
    
    Scenario: Submit a new Service Request Parts POST:
   
   		* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplate.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   serviceRequestCode 						  |
					|       taskCode		    |   taskCode 		  						  |
					|       newSourceId		    |   'Karate-Insert: ' + NewSourceId 		  |
					|       reference           |   'Karate-Insert: ' + NewReference          |


    Given path 'serviceRequests', 'tasks', 'parts'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPartsTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Parts', loadUID, 'UPDATED') == true	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId + '\';'  
  	* def sqlQuery2 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference + '\';'  
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery2, 1) == true
  	
  	#Update to Service Check Point
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'taskId:' + taskId
    When method get
    Then status 200
    And match response $..parts[*].reference contains 'Karate-Insert: ' + NewReference
  	
  	
  	Scenario: Submit a new Service Request Parts POST with an invalid Task Code:
   
   		* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplate.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   serviceRequestCode 						  |
					|       taskCode		    |   'InvalidTaskCodeShouldReturn200' 		  |
					|       reference		    |   'Karate-Insert: ' + NewReference 		  |


    Given path 'serviceRequests', 'tasks', 'parts'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPartsTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Parts', loadUID, 'REJECTED') == true
  	
  	* def sqlQuery = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId + '\';'  
  	* def sqlQuery2 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference + '\';'  
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery2, 0) == true