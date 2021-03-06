#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request {TaskId}, {TaskId/Parts}, {TaskId/Timesheets} GET Method Schema Validation 

  Background:

    #DO NOT MODIFY UNLESS YOUR BRAVE AND YOU KNOW WHAT YOUR DOING*******************************************************
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * def setup = callonce read('classpath:reusable/Generate-Token.feature')
    * def createFullPayload = callonce read('classpath:reusable/CreateFullPayLoad.feature')
    * def Token = setup.token
    * def env = setup.Environment
    * def ch = setup.Channel
    * def payloadTaskId = createFullPayload.fptaskId
    * assert JavaMethods.socks5BypassConfig() == true
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
    #*******************************************************************************************************************

    

    Scenario: Verify all fields are present and data types are correctly defined for Service Request {TaskId}: Short View

    Given path 'serviceRequests', 'tasks/', taskId
    And param view = 'short'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response == { srId: '#string', taskId: '#string', facilityId: '#string'}


	 
	Scenario: Verify all fields are present and data types are correctly defined for Service Request {TaskId}: Medium View
	
    Given path 'serviceRequests', 'tasks/', taskId
    And param view = 'medium'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response ==

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
      "plannedStartDate": ##string
   }
"""


	Scenario: Verify all fields are present and data types are correctly defined for Service Request {TaskId}: Full View

    Given path 'serviceRequests', 'tasks/', payloadTaskId
    And param view = 'full'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response ==

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
      "loadUid": #string,
      "assetId": ##string,
      "assetTblAssetId": "#string",
      "country": "#string",
      "timesheets": [
        {
          "code": #string,
          "projectName": ##string,
          "startDate": ##string,
          "completionDate": ##string,
          "coveredHours": ##number,
          "coveredTravelHours": ##number,
          "overtimeHours": ##number,
          "overtimeTravelHours": ##number,
          "doubleOvertimeHours": ##number,
          "doubleOvertimeTravelHours": ##number,
          "totalHours": ##number,
          "updateDate": ##string,
          "creationDate": ##string,
        }
      ],
      "parts": [
        {
          "description": ##string,
          "reference": #string,
          "quantity": ##number,
          "price": ##number,
          "source": ##string,
          "destination": ##string,
          "partConsumptionSourceSystemId": #string
        }
      ],
      "plannedStartDate": ##string
   }
"""


	Scenario: Verify Wrong Task Id throws 404 for Service Request {TaskId} Method:

    Given path 'serviceRequests', 'tasks/', 'blabidy-bloop'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 404
    And match response $.error == 'Not Found'

	Scenario: Verify invalid Token for Service Request {TaskId} Method:

    Given path 'serviceRequests', 'tasks/', taskId
    * header Authorization = 'Bearer ' + 'some-whack-token'
    When method get
    Then status 401
    And match response $.error == 'invalid_token'


    Scenario: Verify all fields are present and data types are correctly defined for Service Request Tasks: Full View 
		
	Given path 'serviceRequests', 'tasks'
    And param view = 'full'
    And param q = 'taskId:' + payloadTaskId
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.page.size == 1
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
      "loadUid": #string,
      "assetId": ##string,
      "assetTblAssetId": "#string",
      "country": "#string",
      "timesheets": [
        {
          "code": #string,
          "projectName": ##string,
          "startDate": ##string,
          "completionDate": ##string,
          "coveredHours": ##number,
          "coveredTravelHours": ##number,
          "overtimeHours": ##number,
          "overtimeTravelHours": ##number,
          "doubleOvertimeHours": ##number,
          "doubleOvertimeTravelHours": ##number,
          "totalHours": ##number,
          "updateDate": ##string,
          "creationDate": ##string,
        }
      ],
      "parts": [
        {
          "description": ##string,
          "reference": #string,
          "quantity": ##number,
          "price": ##number,
          "source": ##string,
          "destination": ##string,
          "partConsumptionSourceSystemId": #string
        }
      ],
      "plannedStartDate": ##string
   }
"""


 	Scenario: Verify all fields are present and data types are correctly defined for Service Request {Taskid/Parts}
		
	Given path 'serviceRequests', 'tasks/', payloadTaskId, '/parts' 
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response ==

	"""
[
  {
    "description": ##string,
    "reference": #string,
    "quantity": ##number,
    "price": ##number,
    "source": ##string,
    "destination": ##string,
    "partConsumptionSourceSystemId": #string
  }
]
	"""
	
	Scenario: Verify invalid Token for Service Request {TaskId/Parts} Method:

	Given path 'serviceRequests', 'tasks/', payloadTaskId, '/parts' 
    * header Authorization = 'Bearer ' + 'some-whack-token'
    When method get
    Then status 401
    And match response $.error == 'invalid_token'


	Scenario: Verify Wrong Task Id throws 404 for Service Request {TaskId/Parts} Method:

    Given path 'serviceRequests', 'tasks/', 'blabidy-bloop/', 'parts'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 404
    And match response $.error == 'Not Found'

	
	Scenario: Verify all fields are present and data types are correctly defined for Service Request {Taskid/Timesheets}
		
	Given path 'serviceRequests', 'tasks/', payloadTaskId, '/timesheets' 
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response ==

	"""
[
	{
	  "code": #string,
	  "projectName": ##string,
	  "startDate": ##string,
	  "completionDate": ##string,
	  "coveredHours": ##number,
	  "coveredTravelHours": ##number,
	  "overtimeHours": ##number,
	  "overtimeTravelHours": ##number,
	  "doubleOvertimeHours": ##number,
	  "doubleOvertimeTravelHours": ##number,
	  "totalHours": ##number,
	  "updateDate": ##string,
	  "creationDate": ##string,
	}
]
	"""
	
	
	Scenario: Verify invalid Token for Service Request {TaskId/Timesheets} Method:

	Given path 'serviceRequests', 'tasks/', payloadTaskId, '/timesheets' 
    * header Authorization = 'Bearer ' + 'some-whack-token'
    When method get
    Then status 401
    And match response $.error == 'invalid_token'
    
    
   	Scenario: Verify Wrong Task Id throws 404 for Service Request {TaskId/Timesheets} Method:

    Given path 'serviceRequests', 'tasks/', 'blabidy-bloop/', 'timesheets'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 404
    And match response $.error == 'Not Found'