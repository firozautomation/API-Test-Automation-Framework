#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Payload Creation of Service Request, Task, Part, and Timesheet  

    Background:

    #DO NOT MODIFY UNLESS YOUR BRAVE AND YOU KNOW WHAT YOUR DOING*******************************************************
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * def setup = callonce read('classpath:reusable/Generate-Token.feature')
    * def Token = setup.token
    * def env = setup.Environment
    * def ch = setup.Channel
    * assert JavaMethods.socks5BypassConfig() == true
    * call JavaMethods.connectToMongo(env,ch)
    
    
    * url 'http://' + env + '-' + ch + '-shared-services-service-request-service.' + env + '.cloud.ds.gehc.net/serviceRequest/v1/'
    
   		#Retrieves most mandatory values for Service Request GET method from existing payload(s)
	    * def retrieve = callonce read('classpath:reusable/Retrieve-SR-Mandatory-Fields.feature')
	    * def srId = retrieve.fsrId
	    * def taskId = retrieve.ftaskId
	    * def serviceRequestCode = retrieve.fserviceRequestCode
	    * def sourceSystemCode = retrieve.fsourceSystemCode
	    * def taskCode = retrieve.ftaskCode
	    * def assetId = retrieve.fassetId
	    * def assetTblAssetId = retrieve.fassetTblAssetId
	    * def country = retrieve.fcountry
    
     	#Stuff from Java
	    * def NewServiceRequestCode = JavaMethods.generateRandomNumber()
	    * def NewTaskCode = JavaMethods.generateRandomNumber()
   	    * def NewTaskCode = JavaMethods.generateRandomNumber()
   	    * def NewReference = JavaMethods.generateRandomNumber()
	    * def NewSourceId = JavaMethods.generateRandomNumber()	   
	   	* def NewTimesheet = JavaMethods.generateRandomNumber()
	    
   Scenario: Create a Full Payload
   
    	####################################Service Request Payload###############################################
   		* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   'Karate-Insert: ' + NewServiceRequestCode |
					|       assetAvailability   |            'Up'							  |


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'INSERTED') == true
  	
  	
  	#Verify that SOLR has been updated
	Given path 'serviceRequests/'
    * header Authorization = 'Bearer ' + Token
    And param view = 'medium'
    And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    When method get
    Then status 200
    And match response $.content[0].serviceRequestCode == 'Karate-Insert: ' + NewServiceRequestCode
    
    #Useful values that can be reused later
    * def fpserviceRequestCode = $.content[0].serviceRequestCode
    * def fpsourceSystemCode = $.content[0].sourceSystemCode
    * def fpassetTblAssetId = $.content[0].assetTblAssetId
    * def fpcountry = $.content[0].country
    
    ####################################Task Payload##########################################################
    * def ServiceRequestTaskPostTemplate = read('classpath:testsuite/testdata/ServiceRequestTaskTemplate.json')
		* replace ServiceRequestTaskPostTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   fpassetTblAssetId   	 				  |
				    | 		country  			|   fpcountry     		                      |
					| 		sourceSystemCode  	|   fpsourceSystemCode                        |
					| 		serviceRequestCode	|   fpserviceRequestCode 					  |
					|       taskCode		    |   'Karate-Insert: ' + NewTaskCode 		  |


    Given path 'serviceRequests', 'tasks'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTaskPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'INSERTED') == true
  	
  	
  	#Verify that SOLR has been updated
  	Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'medium'
    And param q = 'taskCode:*' + NewTaskCode
    When method get
    Then status 200
    And match response $.page.size == 1
    And match response $.content[0].taskCode == 'Karate-Insert: ' + NewTaskCode


    #Useful values that can be reused later
    * def fptaskId = $.content[0].taskId
    * def fptaskCode = $.content[0].taskCode 
 	     	    

		####################################Part Payload##########################################################
    	* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplate.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   fpassetTblAssetId   	 				  |
				    | 		country  			|   fpcountry     		                      |
					| 		sourceSystemCode  	|   fpsourceSystemCode                        |
					| 		serviceRequestCode	|   fpserviceRequestCode 					  |
					|       taskCode		    |   fptaskCode 		  						  |
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
  	
  	
 		####################################Timesheet Payload##########################################################
  	  	* def ServiceRequestTimesheetTemplate = read('classpath:testsuite/testdata/ServiceRequestTimesheetTemplate.json')
		* replace ServiceRequestTimesheetTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   fpassetTblAssetId   	 				  |
				    | 		country  			|   fpcountry     		                      |
					| 		sourceSystemCode  	|   fpsourceSystemCode                        |
					| 		serviceRequestCode	|   fpserviceRequestCode 					  |
					|       taskCode		    |   fptaskCode 		  						  |
					|       code		    	|   'Karate-Insert: ' + NewTimesheet 		  |


    Given path 'serviceRequests', 'tasks', 'timesheets'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTimesheetTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Timesheet', loadUID, 'INSERTED') == true
  	
  	* print 'Full Payload TaskId = ' + fptaskId
 

  	
  	