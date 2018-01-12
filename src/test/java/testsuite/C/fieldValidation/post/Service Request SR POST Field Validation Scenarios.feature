#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Service POST Field/Attribute Validations 

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
	    * def NewTaskCode = JavaMethods.generateRandomNumber()
    #*******************************************************************************************************************


	Scenario: SR POST: Service Request Source System Validation Field longer than 100 characters

  	* def longSourceSystem = 'Who in the world would want to put more than 100 characters for the source System Code field. Like seriously, this does not make any sense.'
  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   longSourceSystem                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true


	Scenario: SR POST: Service Request sub-Source Description Validation Field longer than 50 characters

  	* def longsubSourceDescription = 'why would anyone put more than 50 characters for a sub-source description code field?'
  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption DSL'		  	  	  |
					|       subSourceDescription   		|     longsubSourceDescription		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true


	Scenario: SR POST: Service Request Country Validation Field longer than 3 characters

  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   'USAA'     		                          |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption DSL'		  	  	  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true


	Scenario: SR POST: Service Request Source Description Validation Field longer than 50 characters

  	* def longSourceDescription = 'why would anyone put more than 50 characters for a source description code field?'
  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     longSourceDescription		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true


  	Scenario: Verify that all appropriate values of service request type code attribute are validated
   
   		* print 'serviceRequestTypeCode: servicerequestcorrective'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'INSERTED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestTypeCode == 'servicerequestcorrective'


  		* print 'serviceRequestTypeCode: servicerequestplanned'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestplanned'		 	      |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestTypeCode == 'servicerequestplanned'


 		* print 'serviceRequestTypeCode: servicerequestinstallationandupgrade'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestinstallationandupgrade' |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestTypeCode == 'servicerequestinstallationandupgrade'


 		* print 'serviceRequestTypeCode: servicerequestrecall'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestrecall'		 	      |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestTypeCode == 'servicerequestrecall'


 		* print 'serviceRequestTypeCode: servicerequestother'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestother'		 	      |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestTypeCode == 'servicerequestother'


 		* print 'serviceRequestTypeCode: servicerequesticenteradmin'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequesticenteradmin'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestTypeCode == 'servicerequesticenteradmin'


 


 	



  	Scenario: Verify that all appropriate values of service request status code attribute are validated
   
   		* print 'serviceRequestStatusCode: Started'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'INSERTED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestStatusCode == 'Started'

   		* print 'serviceRequestStatusCode: Submitted'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Submitted'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestStatusCode == 'Submitted'


   		* print 'serviceRequestStatusCode: Closed'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Closed'		 	 				 	  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestStatusCode == 'Closed'



   		* print 'serviceRequestStatusCode: Closed'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Cancelled'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestStatusCode == 'Cancelled'


   		* print 'serviceRequestStatusCode: Undefined'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Undefined'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'UPDATED') == true
  	
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestStatusCode == 'Undefined'


  		* print 'serviceRequestStatusCode: invalidPattern'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'invalidPattern'		 	 			  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
	

    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	
  	#Maint DB Check Point
  	#* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	#* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
  	
  	
  	#Update to SOLR Check Point
	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.content[0].serviceRequestStatusCode == 'Undefined'


	Scenario: SR POST: Service Request Code Validation Field longer than 50 characters

  	* def longServiceRequestCode = 'why would anyone put more than 50 characters for a service request code field?'
  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   longServiceRequestCode 					  |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true



	Scenario: SR POST: Requester Validation Field longer than 2000 characters

  	* def longRequester = 'Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance'
  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      longRequester		 	  			  |
					|       problem      				|      'Karate DSL'		 	  				  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Problem = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true



	Scenario: SR POST: Remote Validation Field longer than 10 Integers

  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate DSL'		 	  				  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '100'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'				      |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'			  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true



	Scenario: SR POST: Problem Validation Field longer than 2000 characters

  	* def longProblem = 'Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance. Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance'
  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      longProblem		 	  				  |
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
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true



	Scenario: SR POST: Facility Code Validation Field longer than 150 characters

  	* def longFacilityCode = 'Excuse me sir, if you could kindly ingest more than 150 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance'
  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            longFacilityCode				  |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'			  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true



    Scenario: SR POST: AssetId Validation Field longer than 250 characters

  	* def longAssetId = 'Excuse me sir, if you could kindly ingest more than 250 characters of this asset Id field, I would highly appreciate it. You see, it is of upmost importance that we validate this because a very long asset-id should not be accepted for logical reasons. Would you not agree?'
  	
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   longAssetId   	 				      	  |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'					  |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'			  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
    
    
    Scenario: SR POST with Invalid date fields
   
   		* print 'Start Date Validation'
   		* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    yesterdaysDate + 'T15:53:51.597Z'		  |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'					  |
					|       startDate   				|     invalidDate + 'T15:53:51.597Z'		  |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'		  	  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
  
  
     	* print 'Submission Timestamp Validation'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    invalidDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    yesterdaysDate + 'T15:53:51.597Z'		  |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'					  |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'		  	  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
 
 
      	* print 'Source Update Date Validation'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    invalidDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    yesterdaysDate + 'T15:53:51.597Z'		  |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'					  |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'		  	  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
 
  
  
      	* print 'Completion Date Validation'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    invalidDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'					  |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'		  	  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
  
  	
      	* print 'Due Date Validation'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    invalidDate + 'T15:53:51.597Z'		      |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'					  |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'		  	  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true



      	* print 'Availability Date Validation'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    invalidDate + 'T15:53:51.597Z'		      |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'					  |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     todaysDate + 'T15:53:51.597Z'		  	  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true



      	* print 'Requested Timestamp Date Validation'
     	* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceFieldValidationTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 						|   value   	 	  	 				      |
				    | 		assetId   					|   assetTblAssetId   	 				      |
				    | 		country  					|   country     		                      |
					| 		sourceSystemCode  			|   sourceSystemCode                          |
					| 		serviceRequestCode			|   'Karate-Insert: ' + NewServiceRequestCode |
					|       serviceRequestStatusCode    |      'Started'		 	 				  |
					|       serviceRequestTypeCode      |      'servicerequestcorrective'		 	  |
					|       requester      				|      'Karate DSL'		 	  				  |
					|       problem      				|      'Karate Complex Scenario'		 	  |
					|       submissionTimestamp   		|    todaysDate + 'T15:53:51.597Z'	  		  |
					|       sourceUpdateDate   			|    todaysDate + 'T15:53:51.597Z'			  |
				    |       completionDate   			|    todaysDate + 'T15:53:51.597Z'		      |
					|       dueDate   					|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       availabilityDate   			|    tomorrowsDate + 'T15:53:51.597Z'		  |
					|       remotely  				    |            '0'							  |
					|       assetAvailability  		    |            'Up'							  |
					|       facilityCode   				|            'US_294629'					  |
					|       startDate   				|     todaysDate + 'T15:53:51.597Z'		      |
					|       requestedTimestamp   		|     invalidDate + 'T15:53:51.597Z'		  |
					|       sourceDescription   		|     'Karate Desciption'		  	  		  |
					|       subSourceDescription   		|     'Karate Desciption DSL'		  	      |
					


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
  	
  	

  			