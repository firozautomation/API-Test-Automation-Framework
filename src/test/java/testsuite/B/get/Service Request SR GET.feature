#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Service GET Method Parameter Validations 

  Background:

    #DO NOT MODIFY UNLESS YOUR BRAVE AND YOU KNOW WHAT YOUR DOING*******************************************************
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * def setup = callonce read('classpath:reusable/Generate-Token.feature')
    * def Token = setup.token
    * def env = setup.Environment
    * def ch = setup.Channel
    * assert JavaMethods.socks5BypassConfig() == true
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
    
    #Stuff from Java
    * def NewServiceRequestCode = JavaMethods.generateRandomNumber()
    * def NewTaskCode = JavaMethods.generateRandomNumber()
    #*******************************************************************************************************************

    
    
    Scenario: Verify pagination and size query for Service Request GET Method: Page = 50, size = 100

    Given path 'serviceRequests/'
    And param page = 50
	And param size = 100
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.page.number == 50
    And match response $.content.length() == 100


    Scenario: Verify large size query of 1000 records per page for Service Request GET Method

    Given path 'serviceRequests/'
	And param size = 1000
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    And match response $.content.length() == 1000


   	#Scenario: Verify Wrong query throws 404 for Service Request GET Method:

    #Given path 'serviceRequests', 'tasks/', 'blabidy-bloop/', 'timesheets'
    #* header Authorization = 'Bearer ' + Token
    #When method get
    #Then status 404
    #And match response $.error == 'Not Found'

	Scenario: Verify all appropriate fields are present and data types are correctly defined for Service Request: Views = short, medium, and full

	#Small View
	Given path 'serviceRequests/'
	And param view = 'short'
	* header Authorization = 'Bearer ' + Token
	When method get
	Then status 200
	And match response $.page == { number: '#number', total: '#number', size: '#number', next: '#string' }
	And match response $.content[0] == { srId: '#string', assetId: '#string', facilityId: '#string', serviceRequestStatusCode: '#string'}

	#Medium View
    Given path 'serviceRequests/'
    And param view = 'medium'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
	And match response $.page == { number: '#number', total: '#number', size: '#number', next: '#string' }
    And match response $.content[0] ==

  """
  {
        "srId": #string,
        "assetId": #string,
        "facilityId": #string,
        "serviceRequestCode": #string,
        "assetTblAssetId": #string,
        "country": #string,         
        "serviceRequestStatusCode": #string,
        "serviceRequestTypeCode": #string,
        "requester": ##string,
        "requestedTimestamp": ##string,
        "submissionTimestamp": ##string,
        "dueDate": ##string,
        "availabilityDate": ##string,
        "problem": ##string,
        "completionDate": ##string,
        "remotely": #number,
        "sourceDescription": ##string,
        "subSourceDescription": ##string,
        "facilityCode": #string,
        "assetAvailability": #string,
        "sourceSystemCode": #string,
        "indexDate": ##string,
        "sourceUpdateDate": ##string,
        "startDate": ##string,
        "loadUid": ##uuid
   }
"""
    
    #Full View
    Given path 'serviceRequests/'
    And param view = 'full'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
	And match response $.page == { number: '#number', total: '#number', size: '#number', next: '#string' }
    And match response $.content[0] ==

  """
  {
        "srId": #string,
        "assetId": #string,
        "facilityId": #string,
        "serviceRequestCode": #string,
        "assetTblAssetId": #string,
        "country": #string,         
        "serviceRequestStatusCode": #string,
        "serviceRequestTypeCode": #string,
        "requester": ##string,
        "requestedTimestamp": ##string,
        "submissionTimestamp": ##string,
        "dueDate": ##string,
        "availabilityDate": ##string,
        "problem": ##string,
        "completionDate": ##string,
        "remotely": #number,
        "sourceDescription": ##string,
        "subSourceDescription": ##string,
        "facilityCode": #string,
        "assetAvailability": #string,
        "sourceSystemCode": #string,
        "indexDate": ##string,
        "sourceUpdateDate": ##string,
        "startDate": ##string,
        "loadUid": ##uuid
   }
"""


    Scenario: Verify ID parameter and Data Data Type Validations for Service Request GET{ID} Method: All Views

	#Small View
    Given path 'serviceRequests/' + srId
    * header Authorization = 'Bearer ' + Token
	And param view = 'short'
    When method get
    Then status 200
	And match response $.srId == srId
	And match response == { srId: '#string', assetId: '#string', facilityId: '#string', serviceRequestStatusCode: '#string'}

	#Medium View
    Given path 'serviceRequests/' + srId
    And param view = 'medium'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
	And match response $.srId == srId
    And match response ==

  """
  {
        "srId": #string,
        "assetId": #string,
        "facilityId": #string,
        "serviceRequestCode": #string,
        "assetTblAssetId": #string,
        "country": #string,         
        "serviceRequestStatusCode": #string,
        "serviceRequestTypeCode": #string,
        "requester": ##string,
        "requestedTimestamp": ##string,
        "submissionTimestamp": ##string,
        "dueDate": ##string,
        "availabilityDate": ##string,
        "problem": ##string,
        "completionDate": ##string,
        "remotely": #number,
        "sourceDescription": ##string,
        "subSourceDescription": ##string,
        "facilityCode": #string,
        "assetAvailability": #string,
        "sourceSystemCode": #string,
        "indexDate": ##string,
        "sourceUpdateDate": ##string,
        "startDate": ##string,
        "loadUid": ##uuid
   }
"""
    
    #Full View
    Given path 'serviceRequests/' + srId
    And param view = 'full'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
	And match response $.srId == srId
    And match response ==

  """
  {
        "srId": #string,
        "assetId": #string,
        "facilityId": #string,
        "serviceRequestCode": #string,
        "assetTblAssetId": #string,
        "country": #string,         
        "serviceRequestStatusCode": #string,
        "serviceRequestTypeCode": #string,
        "requester": ##string,
        "requestedTimestamp": ##string,
        "submissionTimestamp": ##string,
        "dueDate": ##string,
        "availabilityDate": ##string,
        "problem": ##string,
        "completionDate": ##string,
        "remotely": #number,
        "sourceDescription": ##string,
        "subSourceDescription": ##string,
        "facilityCode": #string,
        "assetAvailability": #string,
        "sourceSystemCode": #string,
        "indexDate": ##string,
        "sourceUpdateDate": ##string,
        "startDate": ##string,
        "loadUid": ##uuid
   }
"""

    Scenario: Verify invalid ID parameter for Service Request GET{ID} Method Returns 404

	#Small View
    Given path 'serviceRequests/' + "blah-blah"
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 404


    #RETURNS 500 Scenario: Verify sorting for Service Request GET Method: Ascending, Desecnding

	
	#Descending
    #Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param sort = 'desc:srId'
    #When method get
    #Then status 200
    
    #Ascending
    #Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param sort = 'asc:srId'
    #When method get
    #Then status 200    
    
    #Both
    #Given path 'serviceRequests/'
    #* header Authorization = 'Bearer ' + Token
    #And param view = 'medium'
    #And param sort = 'asc:srId,desc:taskId'
    #When method get
    #Then status 200
    
    
    Scenario: Verify invalid Token for Service Request GET Method:

    Given path 'serviceRequests/'
    * header Authorization = 'Bearer ' + 'some-whack-token'
    When method get
    Then status 401
    And match response $.error == 'invalid_token'
    
    