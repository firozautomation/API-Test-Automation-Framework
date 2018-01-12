#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Tasks GET Method Schema Validation 

  Background:

    #DO NOT MODIFY UNLESS YOUR BRAVE AND YOU KNOW WHAT YOUR DOING*******************************************************
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * def setup = callonce read('classpath:reusable/Generate-Token.feature')
    * def Token = setup.token
    * def env = setup.Environment
    * def ch = setup.Channel
    * assert JavaMethods.socks5BypassConfig() == true
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
    #*******************************************************************************************************************

    

    Scenario: Verify pagination and size query for Service Request Task GET Method: Page = 50, size = 100

    Given path 'serviceRequests', 'tasks'
    And param page = 50
	And param size = 100
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.page.number == 50
    And match response $.content.length() == 100


    Scenario: Verify large size query of 1000 records per page for Service Request Task GET Method

    Given path 'serviceRequests', 'tasks'
	And param size = 1000
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.content.length() == 1000
    
    
    Scenario: Verify all fields are present and data types are correctly defined for Service Request Tasks: Small View

    Given path 'serviceRequests', 'tasks'
    And param view = 'short'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.page == { number: '#number', total: '#number', size: '#number', next: '#string' }
    And match response $.content[0] == { srId: '#string', taskId: '#string', facilityId: '#string', assetAvailability: '##string'}


	 
	Scenario: Verify all fields are present and data types are correctly defined for Service Request Task: Medium View
	
    Given path 'serviceRequests', 'tasks'
    And param view = 'medium'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.page == { number: '#number', total: '#number', size: '#number', next: '#string' }
    And match response $.content[0] ==

  """
  {
      "srId": "#string",
      "taskId": "#string",
      "facilityId": "#string",
      "taskStatusCode": "#string",
      "facilityCode": "#string",
      "serviceRequestCode": "#string",
      "sourceSystemCode": "#string",
      "taskCode": "#string",
      "taskTypeCode": "#string",
      "cause": "##string",
      "completionDate": "##string",
      "completionStatus": "#string",
      "correctiveAction": "##string",
      "verification": "##string",
      "testResult": "##string",
      "fieldEngineer": "##string",
      "servicedBy": "##string",
      "startDate": "##string",
      "startStatus": "#string",
      "poNumber": ##string,
      "problemCode": "##string",
      "fieldEngineerTimestamp": ##string,
      "coveredHours": ##number,
      "overtimeHours": ##number,
      "doubleOvertimeHours": ##number,
      "coveredTravelHours": ##number,
      "overtimeTravelHours": ##number,
      "doubleOvertimeTravelHours": ##number,
      "indexDate": "##string",
      "sourceUpdateDate": ##string,
      "loadUid": ##uid,
      "assetId": ##string,
      "assetTblAssetId": "#string",
      "country": "#string",
      "plannedStartDate": ##string,
      assetAvailability: '##string'
   }
"""


    Scenario: Verify all fields are present and data types are correctly defined for Service Request GET{ID/Tasks}: Small View
	
    Given path 'serviceRequests/' + srId + '/tasks'
    And param view = 'short'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.page == { number: '#number', total: '#number', size: '#number'}
    And match response $.content[0] == { srId: '#string', taskId: '#string', facilityId: '#string', assetAvailability: '##string'}



    Scenario: Verify all fields are present and data types are correctly defined for Service Request GET{ID/Tasks}: Medium View
	
    Given path 'serviceRequests/' + srId + '/tasks'
    And param view = 'medium'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.page == { number: '#number', total: '#number', size: '#number'}
	And match response $.content[0] ==
  """
  {
      "srId": "#string",
      "taskId": "#string",
      "facilityId": "#string",
      "taskStatusCode": "#string",
      "facilityCode": "#string",
      "serviceRequestCode": "#string",
      "sourceSystemCode": "#string",
      "taskCode": "#string",
      "taskTypeCode": "#string",
      "cause": "##string",
      "completionDate": "##string",
      "completionStatus": "#string",
      "correctiveAction": "##string",
      "verification": "##string",
      "testResult": "##string",
      "fieldEngineer": "##string",
      "servicedBy": "##string",
      "startDate": "##string",
      "startStatus": "#string",
      "poNumber": ##string,
      "problemCode": "##string",
      "fieldEngineerTimestamp": ##string,
      "coveredHours": ##number,
      "overtimeHours": ##number,
      "doubleOvertimeHours": ##number,
      "coveredTravelHours": ##number,
      "overtimeTravelHours": ##number,
      "doubleOvertimeTravelHours": ##number,
      "indexDate": "##string",
      "sourceUpdateDate": ##string,
      "loadUid": ##uid,
      "assetId": ##string,
      "assetTblAssetId": "#string",
      "country": "#string",
      "plannedStartDate": ##string,
      "assetAvailability": '##string'
   }
"""


 	Scenario: Verify invalid ID parameter for Service Request GET{ID/Tasks} Method Returns 404

	#Small View
    Given path 'serviceRequests/blah-blahtasks'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 404


    
   
    #Scenario: Verify query parameter for Service Request GET{ID/Tasks} Method: AND, OR, LIKE

	#Simple Query
    #Given path 'serviceRequests/' + srId + '/tasks'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'srId:' + srId
    #When method get
    #Then status 200
    #And match response $..srId contains srId

	#AND
    #Given path 'serviceRequests/' + srId + '/tasks'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:' + serviceRequestCode + ' AND taskId:' + taskId 
    #When method get
    #Then status 200
    #And match response $..srId contains srId
    
    #OR
    #Given path 'serviceRequests/' + srId + '/tasks'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:neverexists OR srId:' + srId 
    #When method get
    #Then status 200
    #And match response $..srId contains srId
    
    #OR with Like
    #Given path 'serviceRequests/' + srId + '/tasks'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param q = 'serviceRequestCode:neverexists OR srId:*' + srId 
    #When method get
    #Then status 200
    #And match response $..srId contains srId
    
    

    Scenario: Verify invalid Token for Service Request Task Method:

    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + 'some-whack-token'
    When method get
    Then status 401
    And match response $.error == 'invalid_token'


    Scenario: Verify invalid Token for Service Request GET{ID/Tasks} Method:

    Given path 'serviceRequests/' + srId + '/tasks'
    * header Authorization = 'Bearer ' + 'some-whack-token'
    When method get
    Then status 401
    And match response $.error == 'invalid_token'
		