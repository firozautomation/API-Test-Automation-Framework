#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Retrieve Mandatory fields for Service Request Tasks

  Background:

    #DO NOT MODIFY UNLESS YOUR BRAVE AND YOU KNOW WHAT YOUR DOING*******************************************************
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * def setup = callonce read('classpath:reusable/Generate-Token.feature')
    * def Token = setup.token
    * def env = setup.Environment
    * def ch = setup.Channel
    * assert JavaMethods.socks5BypassConfig() == true
    * url 'http://' + env + '-' + ch + '-shared-services-service-request-service.' + env + '.cloud.ds.gehc.net/serviceRequest/v1/'
    #*******************************************************************************************************************

    
    
   
	Scenario: Retrieve Mandatory fields for Service Request Tasks
    Given path 'serviceRequests', 'tasks'
    And param view = 'medium'
    * header Authorization = 'Bearer ' + Token
    When method get
    Then status 200
    
    #Useful values that can be reused later
    * def fsrId = $.content[0].srId
    * def ftaskId = $.content[0].taskId
    * def fserviceRequestCode = $.content[0].serviceRequestCode
    * def fsourceSystemCode = $.content[0].sourceSystemCode
    * def ftaskCode = $.content[0].taskCode
    * def fassetId = $.content[0].assetId
    * def fassetTblAssetId = $.content[0].assetTblAssetId
    * def fcountry = $.content[0].country
    
 
    

  