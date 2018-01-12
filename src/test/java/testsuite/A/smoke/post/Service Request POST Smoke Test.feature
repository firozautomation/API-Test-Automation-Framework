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
  	* assert JavaMethods.checkMongoCollection('Service Request srId', loadUID, 'INSERTED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 1) == true
  	
  	
  	* def srId = JavaMethods.retrieveGlobalsrId()
  	
  	#Update to SOLR Check Point
  	Given path 'serviceRequests/'
    * header Authorization = 'Bearer ' + Token
    And param view = 'medium'
    And param q = 'srId:' + srId
    When method get
    Then status 200
    And match response $.content[0].srId == srId

  	
  	Scenario: Submit a new Service Request POST with an invalid Country Length
   
   		* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId   			|   assetTblAssetId   	 				      |
				    | 		country  			|   'ZZZ'     		                          |
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
  	* assert JavaMethods.checkMongoCollection('Service Request', loadUID, 'FAILED') == true
  	
  	#Maint DB Check Point
  	* def sqlQuery = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* assert JavaMethods.executeSQLQuery(sqlQuery, 0) == true
  	
  	#Update to SOLR Check Point
  	#Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param q = 'serviceRequestCode:*' + NewServiceRequestCode
    #When method get
    #Then status 200
    #And match response $.page.size == 0
  	
  	
    Scenario: Create a new Asset for Service Request POST:
   
   		* def ServiceRequestPostTemplate = read('classpath:testsuite/testdata/ServiceRequestServiceTemplate.json')
		* replace ServiceRequestPostTemplate
					| 		token 				|   value   	 	  	 				      		|
				    | 		assetId   			|   'Karate-CreateAsset-' + NewServiceRequestCode   |
				    | 		country  			|   country     		                      		|
					| 		sourceSystemCode  	|   sourceSystemCode                          		|
					| 		serviceRequestCode	|   'Karate-Insert: ' + NewServiceRequestCode 		|
					|       assetAvailability   |            'Up'							  		|


    Given path 'serviceRequests/'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPostTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Service Request srId', loadUID, 'INSERTED') == true
  	* assert JavaMethods.checkMongoCollection('Asset', loadUID, 'UPDATED') == true
  	
  	* def assetNum = JavaMethods.retrieveAssetNumber()
  	
  	#Maint DB Check Point
  	* def sqlQuery1 = 'SELECT * FROM ServiceRequest WHERE serviceRequestCode LIKE \'%' + NewServiceRequestCode + '\' AND Requester = \'Karate DSL\';'  
  	* def sqlQuery2 = 'SELECT * FROM Asset WHERE AssetId LIKE \'%' + NewServiceRequestCode + '\' AND id = ' + assetNum + ';'  
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery1, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery2, 1) == true
  	
  	* def srId = JavaMethods.retrieveGlobalsrId()
  	
  	#Update to SOLR Check Point
  	Given path 'serviceRequests/'
    * header Authorization = 'Bearer ' + Token
    And param view = 'medium'
    And param q = 'srId:' + srId
    When method get
    Then status 200
    And match response $.content[0].srId == srId  	
		