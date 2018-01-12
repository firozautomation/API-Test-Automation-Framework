#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Service POST Bulk Scenarios 

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
    
    #Return different dates to be used for payload
    * def todaysDate = JavaMethods.returnDate(0,0)
    * def tomorrowsDate = JavaMethods.returnDate(1,0)
    * def yesterdaysDate = JavaMethods.returnDate(-1,0)
    * def invalidDate = JavaMethods.returnDate(0,-1000)
    
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
	    * def NewServiceRequestCode1 = JavaMethods.generateRandomNumber()
	    * def NewServiceRequestCode2 = JavaMethods.generateRandomNumber()
	    * def NewServiceRequestCode3 = JavaMethods.generateRandomNumber()
	    * def NewServiceRequestCode4 = JavaMethods.generateRandomNumber()
	    * def NewServiceRequestCode5 = JavaMethods.generateRandomNumber()
    #*******************************************************************************************************************

	
	Scenario: SR POST: Service Request Bulk: Insert 5 Payloads: 1 Valid, 2 Failures, 2 Rejections
	
		#Insert new payloads
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceComplexTemplate2.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		invalidAssetId   			|   'wrongAssetId'   	 				      |
				    | 		missingAssetId   			|   ''   	 				      			  |
				    | 		country  					|   country     		                      |
				    | 		invalidCountry  			|   'ZZZ'     		                          |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode1			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode1 |
					| 		serviceRequestCode2			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode2 |
					| 		serviceRequestCode3			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode3 |
					| 		missingServiceRequestCode	|  ''										  |
					| 		serviceRequestCode5			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode5 |					
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem1      				|      'Karate Bulk Insert'		 	  	  |
					|       problem2      				|      'Karate Bulk Insert'			 	  |
					|       problem3      				|      'Karate Bulk Insert'			 	  |
					|       problem4      				|      'Karate Bulk Insert'			 	  |
					|       problem5      				|      'Karate Bulk Insert'			 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'				      |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'			  |
					|       sourceDescription   		|     'Karate DSL'		  	  		  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	* def BulkServiceRequestCode = 'Karate-Insert' + NewServiceRequestCode
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'INSERTED') == true
   	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'REJECTED') == true
   	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
 
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + BulkServiceRequestCode + '%\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:Karate-Insert' + NewServiceRequestCode + '* AND problem:Karate Bulk Insert'
    #When method get
    #Then status 200
    #And match response $.page.size == 1
	
	
	Scenario: SR POST: Service Request Bulk: Insert 4 Duplicate Payloads with one Valid Payload
	
		#Insert new payloads
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceComplexTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode1			|  'Karate-Insert' + NewServiceRequestCode 	  |
					| 		serviceRequestCode2			|  'Karate-Insert' + NewServiceRequestCode    |
					| 		serviceRequestCode3			|  'Karate-Insert' + NewServiceRequestCode    |
					| 		serviceRequestCode4			|  'Karate-Insert' + NewServiceRequestCode    |
					| 		serviceRequestCode5			|  'Karate-Insert' + NewServiceRequestCode    |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem1      				|      'Karate Bulk Insert'		 	  	  |
					|       problem2      				|      'Karate Bulk Insert'			 	  |
					|       problem3      				|      'Karate Bulk Insert'			 	  |
					|       problem4      				|      'Karate Bulk Insert'			 	  |
					|       problem5      				|      'Karate Bulk Insert'			 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'				      |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'			  |
					|       sourceDescription   		|     'Karate DSL'		  	  		  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	* def BulkServiceRequestCode = 'Karate-Insert' + NewServiceRequestCode
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'INSERTED') == true
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + BulkServiceRequestCode + '%\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:Karate-Insert' + NewServiceRequestCode + '* AND problem:Karate Bulk Insert'
    #When method get
    #Then status 200
    #And match response $.page.size == 1
	
	
	Scenario: SR POST: Service Request Bulk: Insert 5 Payloads, Update 5 Payloads
	
		#Insert new payloads
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceComplexTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode1			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode1 |
					| 		serviceRequestCode2			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode2 |
					| 		serviceRequestCode3			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode3 |
					| 		serviceRequestCode4			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode4 |
					| 		serviceRequestCode5			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode5 |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem1      				|      'Karate Bulk Insert'		 	  	  |
					|       problem2      				|      'Karate Bulk Insert'			 	  |
					|       problem3      				|      'Karate Bulk Insert'			 	  |
					|       problem4      				|      'Karate Bulk Insert'			 	  |
					|       problem5      				|      'Karate Bulk Insert'			 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'				      |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'			  |
					|       sourceDescription   		|     'Karate DSL'		  	  		  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	* def BulkServiceRequestCode = 'Karate-Insert' + NewServiceRequestCode
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'INSERTED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + BulkServiceRequestCode + '%\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 5) == true
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:Karate-Insert' + NewServiceRequestCode + '* AND problem:Karate Bulk Insert'
    #When method get
    #Then status 200
    #And match response $.page.size == 5
  	
  		#Update existing payloads
  	    * def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceComplexTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode1			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode1 |
					| 		serviceRequestCode2			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode2 |
					| 		serviceRequestCode3			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode3 |
					| 		serviceRequestCode4			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode4 |
					| 		serviceRequestCode5			|  'Karate-Insert' + NewServiceRequestCode + NewServiceRequestCode5 |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem1      				|      'Karate Bulk Update:1'		 	  	  |
					|       problem2      				|      'Karate Bulk Update:2'			 	  |
					|       problem3      				|      'Karate Bulk Update:3'			 	  |
					|       problem4      				|      'Karate Bulk Update:4'			 	  |
					|       problem5      				|      'Karate Bulk Update:5'			 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'				      |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'			  |
					|       sourceDescription   		|     'Karate DSL'		  	  		  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#* def BulkServiceRequestCode = 'Karate-Insert' + NewServiceRequestCode
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + BulkServiceRequestCode + '%\' AND Problem LIKE \'%Karate Bulk Update%\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 5) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:Karate-Insert' + NewServiceRequestCode + '* AND problem:Karate Bulk Update*'
    #When method get
    #Then status 200
    #And match response $.page.size == 5


	  			