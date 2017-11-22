#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Task POST Smoke Test Method Verification 

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
	    * def assetId = retrieve.fassetId
	    * def assetTblAssetId = retrieve.fassetTblAssetId
	    * def country = retrieve.fcountry
	    
	    #Stuff from Java
	    * def NewServiceRequestCode = JavaMethods.generateRandomNumber()
	    * def NewTaskCode = JavaMethods.generateRandomNumber()
	    * def invalidTaskCode = '1234567890gggghgjkdrhgkjdrhgksdhgkjfsdhgkjdhgkjdghkdfhkfjhgkjdhgkljdrhgkljdhjgklshjgkjshgkjdfhgkjdfhgkjdfhgjkdhgkjdhgkjdfhgkjdhgjkhkjghdfjkgfjlkerhgkehklehklehgkjljglkjgellgjekljgklrehjgljkergjlrekjglkejgelrkjfglkjglerjfgrlgjklre' + NewTaskCode
    	* def fullTaskCode = 'Karate-Insert: ' +  invalidTaskCode 	    
    #*******************************************************************************************************************

    
    
    
    Scenario: Submit a new Service Request Task POST:
   
   		* def ServiceRequestTaskPostTemplate = read('classpath:testsuite/testdata/ServiceRequestTaskTemplate.json')
		* replace ServiceRequestTaskPostTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   serviceRequestCode 						  |
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
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM Task WHERE code LIKE \'%' + NewTaskCode + '\' AND cause = \'Karate DSL: Smoke Test\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'medium'
    And param q = 'taskCode:*' + NewTaskCode
    When method get
    Then status 200
    And match response $.content[0].taskCode == 'Karate-Insert: ' + NewTaskCode
  	
    Scenario: Submit a new Service Request Task with a task code more than 200 characters
   
   		* def ServiceRequestTaskPostTemplate = read('classpath:testsuite/testdata/ServiceRequestTaskTemplate.json')
		* replace ServiceRequestTaskPostTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   serviceRequestCode 						  |
					|       taskCode		    |   'Karate-Insert: ' + invalidTaskCode 	  |


    Given path 'serviceRequests', 'tasks'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTaskPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200 
  	
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM Task WHERE code LIKE \'%' + invalidTaskCode + '\' AND cause = \'Karate DSL: Smoke Test\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
  	

  	
  	
  	Scenario: Submit a new Service Request Task with an invalid Service Request Code
   
   		* def ServiceRequestTaskPostTemplate = read('classpath:testsuite/testdata/ServiceRequestTaskTemplate.json')
		* replace ServiceRequestTaskPostTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   country     		                      |
					| 		sourceSystemCode  	|   sourceSystemCode                          |
					| 		serviceRequestCode	|   'fakeServiceRequestShouldReturn200' 	  |
					|       taskCode		    |   'Karate-Insert: ' + NewTaskCode 		  |


    Given path 'serviceRequests', 'tasks'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTaskPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'REJECTED') == true 
  	
  	* def sqlQuery = 'SELECT * FROM Task WHERE code LIKE \'%' + NewTaskCode + '\' AND cause = \'Karate DSL: Smoke Test\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
  	
  	 	 			