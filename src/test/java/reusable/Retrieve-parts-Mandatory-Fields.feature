#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Retrieve Mandatory fields for Service Request Parts Setup

  Background:

    #DO NOT MODIFY UNLESS YOUR BRAVE AND YOU KNOW WHAT YOUR DOING*******************************************************
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * def env = setup.Environment
    * def ch = setup.Channel
    * assert JavaMethods.socks5BypassConfig() == true
    #*******************************************************************************************************************

    
    
   
	Scenario: Retrieve multiple task attributes based on DB Call
	
	* assert JavaMethods.executeSQLQueryForExistingTasks() == true
	

    #5 sets of data to be used for Parts Complex Scenenarios
    * def fServiceRequestCode1 = JavaMethods.returnResultsForPartsSetup(1, 'ServiceRequestCode')
    * def fServiceRequestCode2 = JavaMethods.returnResultsForPartsSetup(2, 'ServiceRequestCode')
    * def fServiceRequestCode3 = JavaMethods.returnResultsForPartsSetup(3, 'ServiceRequestCode')
    * def fServiceRequestCode4 = JavaMethods.returnResultsForPartsSetup(4, 'ServiceRequestCode')
    * def fServiceRequestCode5 = JavaMethods.returnResultsForPartsSetup(5, 'ServiceRequestCode')
    
    * def fAssetTblAssetId1 = JavaMethods.returnResultsForPartsSetup(1, 'AssetTblAssetId')
    * def fAssetTblAssetId2 = JavaMethods.returnResultsForPartsSetup(2, 'AssetTblAssetId')
    * def fAssetTblAssetId3 = JavaMethods.returnResultsForPartsSetup(3, 'AssetTblAssetId')
    * def fAssetTblAssetId4 = JavaMethods.returnResultsForPartsSetup(4, 'AssetTblAssetId')
    * def fAssetTblAssetId5 = JavaMethods.returnResultsForPartsSetup(5, 'AssetTblAssetId')
    
    * def fSourceSystemCode1 = JavaMethods.returnResultsForPartsSetup(1, 'SourceSystemCode')
    * def fSourceSystemCode2 = JavaMethods.returnResultsForPartsSetup(2, 'SourceSystemCode')
    * def fSourceSystemCode3 = JavaMethods.returnResultsForPartsSetup(3, 'SourceSystemCode')
    * def fSourceSystemCode4 = JavaMethods.returnResultsForPartsSetup(4, 'SourceSystemCode')
    * def fSourceSystemCode5 = JavaMethods.returnResultsForPartsSetup(5, 'SourceSystemCode')
    
    * def fCountry1 = JavaMethods.returnResultsForPartsSetup(1, 'Country')
    * def fCountry2 = JavaMethods.returnResultsForPartsSetup(2, 'Country')
    * def fCountry3 = JavaMethods.returnResultsForPartsSetup(3, 'Country')
    * def fCountry4 = JavaMethods.returnResultsForPartsSetup(4, 'Country')
    * def fCountry5 = JavaMethods.returnResultsForPartsSetup(5, 'Country')
    
    * def fTaskCode1 = JavaMethods.returnResultsForPartsSetup(1, 'TaskCode')
    * def fTaskCode2 = JavaMethods.returnResultsForPartsSetup(2, 'TaskCode')
    * def fTaskCode3 = JavaMethods.returnResultsForPartsSetup(3, 'TaskCode')
    * def fTaskCode4 = JavaMethods.returnResultsForPartsSetup(4, 'TaskCode')
    * def fTaskCode5 = JavaMethods.returnResultsForPartsSetup(5, 'TaskCode')
