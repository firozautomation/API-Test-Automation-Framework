#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Timesheets POST Smoke Test 

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
	    * def NewTimesheet = JavaMethods.generateRandomNumber()
    #*******************************************************************************************************************

    
    
    
    Scenario: Submit a new Service Request Timesheets POST:
   
   		* def ServiceRequestTimesheetTemplate = read('classpath:testsuite/testdata/ServiceRequestTimesheetTemplate.json')
		* replace ServiceRequestTimesheetTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   serviceRequestCode 						  |
					|       taskCode		    |   taskCode 		  						  |
					|       code		    	|   'Karate-Insert: ' + NewTimesheet 		  |


    Given path 'serviceRequests', 'tasks', 'timesheets'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTimesheetTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Timesheet', loadUID, 'INSERTED') == true
  	
  	* def sqlQuery = 'SELECT * FROM TimeSheet WHERE Code LIKE \'%' + NewTimesheet + '\' AND ProjectName = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	#Update to Service Check Point
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'taskId:' + taskId
    When method get
    Then status 200
    And match response $..timesheets[*].code contains 'Karate-Insert: ' + NewTimesheet
  	
  	
  	Scenario: Submit a new Service Request Timesheets POST with an invalid Task Code
   
   		* def ServiceRequestTimesheetTemplate = read('classpath:testsuite/testdata/ServiceRequestTimesheetTemplate.json')
		* replace ServiceRequestTimesheetTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   serviceRequestCode 						  |
					|       taskCode		    |   'InvalidTaskCodeShouldReturn200' 		  |
					|       code		    	|   'Karate-Insert: ' + NewTimesheet 		  |


    Given path 'serviceRequests', 'tasks', 'timesheets'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTimesheetTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Timesheet', loadUID, 'REJECTED') == true  	
  	
  	* def sqlQuery = 'SELECT * FROM TimeSheet WHERE Code LIKE \'%' + NewTimesheet + '\' AND ProjectName = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
  	
  	
    