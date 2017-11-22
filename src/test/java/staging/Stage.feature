#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Parts POST Bulk Scenarios

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
    
   		#Retrieves most mandatory values for Service Request Task GET method from existing payload(s)
	    * def retrieve = callonce read('classpath:reusable/Retrieve-parts-Mandatory-Fields.feature')
	    
	    * def ServiceRequestCodeRecord1 = retrieve.fServiceRequestCode1
	    * def ServiceRequestCodeRecord2 = retrieve.fServiceRequestCode2
	    * def ServiceRequestCodeRecord3 = retrieve.fServiceRequestCode3
	    * def ServiceRequestCodeRecord4 = retrieve.fServiceRequestCode4
	    * def ServiceRequestCodeRecord5 = retrieve.fServiceRequestCode5
	    
	    * def AssetTblAssetIdRecord1 = retrieve.fAssetTblAssetId1
	    * def AssetTblAssetIdRecord2 = retrieve.fAssetTblAssetId2
	    * def AssetTblAssetIdRecord3 = retrieve.fAssetTblAssetId3
	    * def AssetTblAssetIdRecord4 = retrieve.fAssetTblAssetId4
	    * def AssetTblAssetIdRecord5 = retrieve.fAssetTblAssetId5
	    
	    * def SourceSystemCodeRecord1 = retrieve.fSourceSystemCode1
	    * def SourceSystemCodeRecord2 = retrieve.fSourceSystemCode2
	    * def SourceSystemCodeRecord3 = retrieve.fSourceSystemCode3
	    * def SourceSystemCodeRecord4 = retrieve.fSourceSystemCode4
	    * def SourceSystemCodeRecord5 = retrieve.fSourceSystemCode5
	    
	    * def CountryRecord1 = retrieve.fCountry1
	    * def CountryRecord2 = retrieve.fCountry2
	    * def CountryRecord3 = retrieve.fCountry3
	    * def CountryRecord4 = retrieve.fCountry4
	    * def CountryRecord5 = retrieve.fCountry5
	    
	    * def TaskCodeRecord1 = retrieve.fTaskCode1
	    * def TaskCodeRecord2 = retrieve.fTaskCode2
	    * def TaskCodeRecord3 = retrieve.fTaskCode3
	    * def TaskCodeRecord4 = retrieve.fTaskCode4
	    * def TaskCodeRecord5 = retrieve.fTaskCode5
	    
	    
	    #Stuff from Java
	    * def NewReference1 = JavaMethods.generateRandomNumber()
	    * def NewSourceId1 = JavaMethods.generateRandomNumber()	    
	    * def NewReference2 = JavaMethods.generateRandomNumber()
	    * def NewSourceId2 = JavaMethods.generateRandomNumber()	
	    * def NewReference3 = JavaMethods.generateRandomNumber()
	    * def NewSourceId3 = JavaMethods.generateRandomNumber()	
	    * def NewReference4 = JavaMethods.generateRandomNumber()
	    * def NewSourceId4 = JavaMethods.generateRandomNumber()	
	    * def NewReference5 = JavaMethods.generateRandomNumber()
	    * def NewSourceId5 = JavaMethods.generateRandomNumber()		    	    	    	    
    #*******************************************************************************************************************

    
    
    Scenario: Insert 3 new Parts Try to Update 2 of the Inserts and Insert 1 More Valid Part
   
   		* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplateComplex.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId1   			|   AssetTblAssetIdRecord1				   	  |
				    | 		assetId2   			|   AssetTblAssetIdRecord2   	 			  |
				    | 		assetId3   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId4   			|   AssetTblAssetIdRecord2   	 			  |
				    | 		assetId5   			|   AssetTblAssetIdRecord5   	 			  |
				    
				    | 		country1  			|   CountryRecord1     		                  |
				    | 		country2  			|   CountryRecord2   		                  |
				    | 		country3  			|   CountryRecord1     		                  |
				    | 		country4  			|   CountryRecord2     		                  |
				    | 		country5  			|   CountryRecord5     		                  |
				    
					| 		sourceSystemCode1  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode2  	|   SourceSystemCodeRecord2                   |
					| 		sourceSystemCode3  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode4  	|   SourceSystemCodeRecord2                   |
					| 		sourceSystemCode5  	|   SourceSystemCodeRecord5                   |
					
					| 		serviceRequestCode1	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode2	|   ServiceRequestCodeRecord2 			      |
					| 		serviceRequestCode3	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode4	|   ServiceRequestCodeRecord2 			      |
					| 		serviceRequestCode5	|   ServiceRequestCodeRecord5 			      |
					
					|       taskCode1		    |   TaskCodeRecord1 		  			      |
					|       taskCode2		    |   TaskCodeRecord2 		  			      |
					|       taskCode3		    |   TaskCodeRecord1 		  			      |
					|       taskCode4		    |   TaskCodeRecord2 		  			      |
					|       taskCode5		    |   TaskCodeRecord5 		  			      |
					
					|       newSourceId1		|   NewSourceId1 + 'Karate-Insert' 	 		  |
					|       newSourceId2		|   NewSourceId2 + 'Karate-Insert' 	  		  |
					|       newSourceId3		|   NewSourceId1 + 'Karate-Insert' 	  		  |
					|       newSourceId4		|   NewSourceId2 + 'Karate-Insert'		 	  |
					|       newSourceId5		|   'Karate-Insert' + NewSourceId5 	  		  |
					
					|       reference1          |   NewReference1 + 'Karate-Insert'		      |
					|       reference2          |   NewReference2 + 'Karate-Insert'     	  |
					|       reference3          |   NewReference1 + 'Karate-Insert'      	  |
					|       reference4          |   NewReference2 + 'Karate-Insert'     	  |
					|       reference5          |   'Karate-Insert' + NewReference5 	      |
					
					|       description1		|		'No. 1 left-handed Hex bolt'		  |
					|       description2		|		'No. 1 left-handed Hex bolt'		  |
					|       description3		|		'No. 1 left-handed Hex bolt Update'	  |
					|       description4		|		'No. 1 left-handed Hex bolt Update'	  |
					|       description5		|		'No. 1 left-handed Hex bolt'		  |


    Given path 'serviceRequests', 'tasks', 'parts'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPartsTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Parts', loadUID, 'UPDATED') == true	
  	* assert JavaMethods.checkMongoCollection('Parts', loadUID, 'FAILED') == true	
  	
  	* def sqlQuery1 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId1 + '%\';'  
  	* def sqlQuery2 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference1 + '\';'   
  	
  	 * def sqlQuery1 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId5 + '\';'  
  	* def sqlQuery2 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference5 + '\';' 	  	
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery1, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery2, 1) == true
  	 	 	  	  	
  	

    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord1 + ' AND taskCode:' + TaskCodeRecord1
    When method get
    Then status 200
    And match response $..parts[*].reference contains NewReference1 + 'Karate-Insert'


    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord5 + ' AND taskCode:' + TaskCodeRecord5
    When method get
    Then status 200
    And match response $..parts[*].reference contains 'Karate-Insert' + NewReference5


  	
  	