#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Task POST Bulk Scenarios 

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
	    * def NewTaskCode1 = JavaMethods.generateRandomNumber()
	    * def NewTaskCode2 = JavaMethods.generateRandomNumber()
	    * def NewTaskCode3 = JavaMethods.generateRandomNumber()
	    * def NewTaskCode4 = JavaMethods.generateRandomNumber()
	    * def NewTaskCode5 = JavaMethods.generateRandomNumber()
    #*******************************************************************************************************************

    
  		Scenario: SR POST Task Bulk: Insert 5 Payloads, Update 5 Payloads 
   
   		* def ServiceRequestTaskPostTemplate = read('classpath:testsuite/testdata/ServiceRequestTaskComplexTemplate2.json')
		* replace ServiceRequestTaskPostTemplate
					| 		token 				|   value   	 	  	 				      			  |
				    | 		assetId   			|   assetTblAssetId   	 				      			  |
				    | 		country  			|   country     		                      			  |
					| 		sourceSystemCode  	|   sourceSystemCode                          			  |
					| 		serviceRequestCode	|   serviceRequestCode 						  			  |
					|       testResult1         |    'Looking prety good1'                                |
					|       testResult2         |    'Looking prety good2'                                |
					|       testResult3         |    'Looking prety good3'                                |
					|       testResult4         |    'Looking prety good4'                                |
					|       testResult5         |    'Looking prety good5'                                |
					|       taskCode1		    |   'Karate-Insert' + NewTaskCode + NewTaskCode1		  |
					|       taskCode2		    |   'Karate-Insert' + NewTaskCode + NewTaskCode2		  |
					|       taskCode3		    |   'Karate-Insert' + NewTaskCode + NewTaskCode3		  |
					|       taskCode4		    |   'Karate-Insert' + NewTaskCode + NewTaskCode4		  |
					|       taskCode5		    |   'Karate-Insert' + NewTaskCode + NewTaskCode5	  	  |


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
  	* def sqlQuery = 'SELECT * FROM Task WHERE code LIKE \'%' + NewTaskCode + '%\' AND cause = \'Karate DSL: Smoke Test\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 5) == true
  	
  	
  	#Update to SOLR Check Point
    #Given path 'serviceRequests', 'tasks'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'taskCode:Karate-Insert' + NewTaskCode + '*'
    #When method get
    #Then status 200
    #And match response $.page.size == 5

		#Update
  		* def ServiceRequestTaskPostTemplate = read('classpath:testsuite/testdata/ServiceRequestTaskComplexTemplate2.json')
		* replace ServiceRequestTaskPostTemplate
					| 		token 				|   value   	 	  	 				      			  |
				    | 		assetId   			|   assetTblAssetId   	 				      			  |
				    | 		country  			|   country     		                      			  |
					| 		sourceSystemCode  	|   sourceSystemCode                          			  |
					| 		serviceRequestCode	|   serviceRequestCode 						  			  |
					|       testResult1         |    'Update Looking prety good'                          |
					|       testResult2         |    'Update Looking prety good2'                         |
					|       testResult3         |    'Update Looking prety good3'                         |
					|       testResult4         |    'Update Looking prety good4'                         |
					|       testResult5         |    'Update Looking prety good5'                         |
					|       taskCode1		    |   'Karate-Insert' + NewTaskCode + NewTaskCode1		  |
					|       taskCode2		    |   'Karate-Insert' + NewTaskCode + NewTaskCode2		  |
					|       taskCode3		    |   'Karate-Insert' + NewTaskCode + NewTaskCode3		  |
					|       taskCode4		    |   'Karate-Insert' + NewTaskCode + NewTaskCode4		  |
					|       taskCode5		    |   'Karate-Insert' + NewTaskCode + NewTaskCode5	  	  |


    Given path 'serviceRequests', 'tasks'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTaskPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'UPDATED') == true

  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM Task WHERE code LIKE \'%' + NewTaskCode + '%\' AND TestResult Like \'Update Looking prety good%\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 5) == true
  	
  	
  	#Update to SOLR Check Point
   # Given path 'serviceRequests', 'tasks'
   # * header Authorization = 'Bearer ' + Token
   # And param view = 'medium'
   # And param q = 'taskCode:Karate-Insert' + NewTaskCode + '* AND testResult:Update Looking prety good*'
   # When method get
   # Then status 200
   # And match response $.page.size == 5

  
    
		Scenario: SR POST Task Bulk: Insert 4 Duplicate Payloads with one Valid Payload
   
   		* def ServiceRequestTaskPostTemplate = read('classpath:testsuite/testdata/ServiceRequestTaskComplexTemplate2.json')
		* replace ServiceRequestTaskPostTemplate
					| 		token 				|   value   	 	  	 				      			  |
				    | 		assetId   			|   assetTblAssetId   	 				      			  |
				    | 		country  			|   country     		                      			  |
					| 		sourceSystemCode  	|   sourceSystemCode                          			  |
					| 		serviceRequestCode	|   serviceRequestCode 						  			  |
					|       testResult1         |    'Looking prety good1'                                |
					|       testResult2         |    'Looking prety good2'                                |
					|       testResult3         |    'Looking prety good3'                                |
					|       testResult4         |    'Looking prety good4'                                |
					|       testResult5         |    'Looking prety good5'                                |
					|       taskCode1		    |   'Karate-Insert' + NewTaskCode						  |
					|       taskCode2		    |   'Karate-Insert' + NewTaskCode						  |
					|       taskCode3		    |   'Karate-Insert' + NewTaskCode						  |
					|       taskCode4		    |   'Karate-Insert' + NewTaskCode						  |
					|       taskCode5		    |   'Karate-Insert' + NewTaskCode 					  	  |


    Given path 'serviceRequests', 'tasks'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTaskPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'INSERTED') == true
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM Task WHERE code LIKE \'%' + NewTaskCode + '\' AND cause = \'Karate DSL: Smoke Test\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
   # Given path 'serviceRequests', 'tasks'
   # * header Authorization = 'Bearer ' + Token
   # And param view = 'medium'
   # And param q = 'taskCode:Karate-Insert' + NewTaskCode
   # When method get
   # Then status 200
   # And match response $.page.size == 1
 
 
    
	Scenario: SR Task POST Bulk: Insert 5 Payloads: 1 Valid, 2 Failures, 2 Rejections
   
   		* def ServiceRequestTaskPostTemplate = read('classpath:testsuite/testdata/ServiceRequestTaskComplexTemplate.json')
		* replace ServiceRequestTaskPostTemplate
					| 		token 				|   value   	 	  	 				      			  |
				    | 		assetId   			|   assetTblAssetId   	 				      			  |
				    | 		MissingassetId   	|   ''   	 				      			 			  |
				    | 		country  			|   country     		                      			  |
				    | 		Invalidcountry  	|   'ZZZ'     		                      			      |
					| 		sourceSystemCode  	|   sourceSystemCode                          			  |
					| 		IncorrectsourceSystemCode  	|   'invalidSource'                          	  |
					| 		serviceRequestCode	|   serviceRequestCode 						  			  |
					| 		InvalidserviceRequestCode	|   'invalidServiceRequestCode' 				  |
					|       taskCode1		    |   'Karate-Insert' + NewTaskCode + NewTaskCode1 		  |
					|       taskCode2		    |   'Karate-Insert' + NewTaskCode + NewTaskCode2		  |
					|       taskCode3		    |   'Karate-Insert' + NewTaskCode + NewTaskCode3		  |
					|       taskCode4		    |   'Karate-Insert' + NewTaskCode + NewTaskCode4		  |
					|       taskCode5		    |   'Karate-Insert' + NewTaskCode + NewTaskCode5	  	  |


    Given path 'serviceRequests', 'tasks'
    And header Content-Type = 'application/json'
   	And request ServiceRequestTaskPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'INSERTED') == true
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'FAILED') == true
  	* assert JavaMethods.checkMongoCollection('Tasks', loadUID, 'REJECTED') == true

  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM Task WHERE code LIKE \'%' + NewTaskCode + '%\' AND cause = \'Karate DSL: Smoke Test\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
    #Given path 'serviceRequests', 'tasks'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'taskCode:Karate-Insert' + NewTaskCode + '*'
    #When method get
    #Then status 200
    #And match response $.page.size == 1
  	
   			