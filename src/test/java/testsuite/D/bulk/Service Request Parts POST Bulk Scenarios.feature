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

    
    
    Scenario: Submit 5 new Service Request Parts and Then Update them: Each part has a different assetId and Service Request, and TaskCode combination
   
   		* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplateComplex.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId1   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId2   			|   AssetTblAssetIdRecord2   	 			  |
				    | 		assetId3   			|   AssetTblAssetIdRecord3   	 			  |
				    | 		assetId4   			|   AssetTblAssetIdRecord4   	 			  |
				    | 		assetId5   			|   AssetTblAssetIdRecord5   	 			  |
				    
				    | 		country1  			|   CountryRecord1     		                  |
				    | 		country2  			|   CountryRecord2     		                  |
				    | 		country3  			|   CountryRecord3     		                  |
				    | 		country4  			|   CountryRecord4     		                  |
				    | 		country5  			|   CountryRecord5     		                  |
				    
					| 		sourceSystemCode1  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode2  	|   SourceSystemCodeRecord2                   |
					| 		sourceSystemCode3  	|   SourceSystemCodeRecord3                   |
					| 		sourceSystemCode4  	|   SourceSystemCodeRecord4                   |
					| 		sourceSystemCode5  	|   SourceSystemCodeRecord5                   |
					
					| 		serviceRequestCode1	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode2	|   ServiceRequestCodeRecord2 			      |
					| 		serviceRequestCode3	|   ServiceRequestCodeRecord3 			      |
					| 		serviceRequestCode4	|   ServiceRequestCodeRecord4 			      |
					| 		serviceRequestCode5	|   ServiceRequestCodeRecord5 			      |
					
					|       taskCode1		    |   TaskCodeRecord1 		  			      |
					|       taskCode2		    |   TaskCodeRecord2 		  			      |
					|       taskCode3		    |   TaskCodeRecord3 		  			      |
					|       taskCode4		    |   TaskCodeRecord4 		  			      |
					|       taskCode5		    |   TaskCodeRecord5 		  			      |
					
					|       newSourceId1		|   'Karate-Insert' + NewSourceId1 		      |
					|       newSourceId2		|   'Karate-Insert' + NewSourceId2 		      |
					|       newSourceId3		|   'Karate-Insert' + NewSourceId3 		      |
					|       newSourceId4		|   'Karate-Insert' + NewSourceId4 		      |
					|       newSourceId5		|   'Karate-Insert' + NewSourceId5 		      |
					
					|       reference1          |   'Karate-Insert' + NewReference1           |
					|       reference2          |   'Karate-Insert' + NewReference2           |
					|       reference3          |   'Karate-Insert' + NewReference3           |
					|       reference4          |   'Karate-Insert' + NewReference4           |
					|       reference5          |   'Karate-Insert' + NewReference5           |
					
					|       description1		|		'No. 1 left-handed Hex bolt'		  |
					|       description2		|		'No. 2 left-handed Hex bolt'		  |
					|       description3		|		'No. 3 left-handed Hex bolt'		  |
					|       description4		|		'No. 4 left-handed Hex bolt'		  |
					|       description5		|		'No. 5 left-handed Hex bolt'		  |


    Given path 'serviceRequests', 'tasks', 'parts'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPartsTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Parts', loadUID, 'UPDATED') == true	
  	
  	#Maint DB Check Point
  	* def sqlQuery1 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId1 + '\';'  
  	* def sqlQuery2 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference1 + '\';'  
  	
  	* def sqlQuery3 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId2 + '\';'  
  	* def sqlQuery4 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference2 + '\';' 
  	
  	* def sqlQuery5 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId3 + '\';'  
  	* def sqlQuery6 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference3 + '\';' 
  	
  	* def sqlQuery7 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId4 + '\';'  
  	* def sqlQuery8 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference4 + '\';' 
  	
  	* def sqlQuery9 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId5 + '\';'  
  	* def sqlQuery10 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference5 + '\';'   	  	
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery1, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery2, 1) == true
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery3, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery4, 1) == true
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery5, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery6, 1) == true
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery7, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery8, 1) == true 
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery9, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery10, 1) == true  	 	  	  	
  	
  	#Update to Service Check Point for Record 1
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord1 + ' AND taskCode:' + TaskCodeRecord1
    When method get
    Then status 200
    And match response $..parts[*].reference contains 'Karate-Insert' + NewReference1

  	#Update to Service Check Point for Record 2
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord2 + ' AND taskCode:' + TaskCodeRecord2
    When method get
    Then status 200
    And match response $..parts[*].reference contains 'Karate-Insert' + NewReference2


  	#Update to Service Check Point for Record 3
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord3 + ' AND taskCode:' + TaskCodeRecord3
    When method get
    Then status 200
    And match response $..parts[*].reference contains 'Karate-Insert' + NewReference3


  	#Update to Service Check Point for Record 4
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord4 + ' AND taskCode:' + TaskCodeRecord4
    When method get
    Then status 200
    And match response $..parts[*].reference contains 'Karate-Insert' + NewReference4


  	#Update to Service Check Point for Record 5
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord5 + ' AND taskCode:' + TaskCodeRecord5
    When method get
    Then status 200
    And match response $..parts[*].reference contains 'Karate-Insert' + NewReference5 

		#Perform an update
   		* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplateComplex.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId1   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId2   			|   AssetTblAssetIdRecord2   	 			  |
				    | 		assetId3   			|   AssetTblAssetIdRecord3   	 			  |
				    | 		assetId4   			|   AssetTblAssetIdRecord4   	 			  |
				    | 		assetId5   			|   AssetTblAssetIdRecord5   	 			  |
				    
				    | 		country1  			|   CountryRecord1     		                  |
				    | 		country2  			|   CountryRecord2     		                  |
				    | 		country3  			|   CountryRecord3     		                  |
				    | 		country4  			|   CountryRecord4     		                  |
				    | 		country5  			|   CountryRecord5     		                  |
				    
					| 		sourceSystemCode1  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode2  	|   SourceSystemCodeRecord2                   |
					| 		sourceSystemCode3  	|   SourceSystemCodeRecord3                   |
					| 		sourceSystemCode4  	|   SourceSystemCodeRecord4                   |
					| 		sourceSystemCode5  	|   SourceSystemCodeRecord5                   |
					
					| 		serviceRequestCode1	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode2	|   ServiceRequestCodeRecord2 			      |
					| 		serviceRequestCode3	|   ServiceRequestCodeRecord3 			      |
					| 		serviceRequestCode4	|   ServiceRequestCodeRecord4 			      |
					| 		serviceRequestCode5	|   ServiceRequestCodeRecord5 			      |
					
					|       taskCode1		    |   TaskCodeRecord1 		  			      |
					|       taskCode2		    |   TaskCodeRecord2 		  			      |
					|       taskCode3		    |   TaskCodeRecord3 		  			      |
					|       taskCode4		    |   TaskCodeRecord4 		  			      |
					|       taskCode5		    |   TaskCodeRecord5 		  			      |
					
					|       newSourceId1		|   'Karate-Insert' + NewSourceId1 		      |
					|       newSourceId2		|   'Karate-Insert' + NewSourceId2 		      |
					|       newSourceId3		|   'Karate-Insert' + NewSourceId3 		      |
					|       newSourceId4		|   'Karate-Insert' + NewSourceId4 		      |
					|       newSourceId5		|   'Karate-Insert' + NewSourceId5 		      |
					
					|       reference1          |   'Karate-Insert' + NewReference1           |
					|       reference2          |   'Karate-Insert' + NewReference2           |
					|       reference3          |   'Karate-Insert' + NewReference3           |
					|       reference4          |   'Karate-Insert' + NewReference4           |
					|       reference5          |   'Karate-Insert' + NewReference5           |
					
					|       description1		|		'No. 1 left-handed Hex bolt UPDATE'	  |
					|       description2		|		'No. 2 left-handed Hex bolt UPDATE'	  |
					|       description3		|		'No. 3 left-handed Hex bolt UPDATE'	  |
					|       description4		|		'No. 4 left-handed Hex bolt UPDATE'	  |
					|       description5		|		'No. 5 left-handed Hex bolt UPDATE'	  | 
					
	
	Given path 'serviceRequests', 'tasks', 'parts'
    And header Content-Type = 'application/json'
   	And request ServiceRequestPartsTemplate
  	* header Authorization = 'Bearer ' + Token
  	When method post
  	Then status 200
  	
  	#Mongo Check Point
  	* def loadUID = $.loadId
  	* assert JavaMethods.checkMongoCollection('Parts', loadUID, 'UPDATED') == true
  	
  	
  	#Update to Service Check Point for Record 1
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord1 + ' AND taskCode:' + TaskCodeRecord1
    When method get
    Then status 200
    #And match response contains { description: ['No. 1 left-handed Hex bolt UPDATE'], partConsumptionSourceSystemId: ['Karate-Insert' + NewSourceId1] }
    And match response $..parts[*].description contains 'No. 1 left-handed Hex bolt UPDATE'

  	#Update to Service Check Point for Record 2
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord2 + ' AND taskCode:' + TaskCodeRecord2
    When method get
    Then status 200
    And match response $..parts[*].description contains 'No. 2 left-handed Hex bolt UPDATE'


  	#Update to Service Check Point for Record 3
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord3 + ' AND taskCode:' + TaskCodeRecord3
    When method get
    Then status 200
    And match response $..parts[*].description contains 'No. 3 left-handed Hex bolt UPDATE'


  	#Update to Service Check Point for Record 4
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord4 + ' AND taskCode:' + TaskCodeRecord4
    When method get
    Then status 200
    And match response $..parts[*].description contains 'No. 4 left-handed Hex bolt UPDATE'


  	#Update to Service Check Point for Record 5
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord5 + ' AND taskCode:' + TaskCodeRecord5
    When method get
    Then status 200
    And match response $..parts[*].description contains 'No. 5 left-handed Hex bolt UPDATE'



	Scenario: Insert 5 Duplicate Reference Parts for each new Part Type Consumption
   
   		* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplateComplex.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId1   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId2   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId3   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId4   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId5   			|   AssetTblAssetIdRecord1   	 			  |
				    
				    | 		country1  			|   CountryRecord1     		                  |
				    | 		country2  			|   CountryRecord1     		                  |
				    | 		country3  			|   CountryRecord1     		                  |
				    | 		country4  			|   CountryRecord1     		                  |
				    | 		country5  			|   CountryRecord1     		                  |
				    
					| 		sourceSystemCode1  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode2  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode3  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode4  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode5  	|   SourceSystemCodeRecord1                   |
					
					| 		serviceRequestCode1	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode2	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode3	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode4	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode5	|   ServiceRequestCodeRecord1 			      |
					
					|       taskCode1		    |   TaskCodeRecord1 		  			      |
					|       taskCode2		    |   TaskCodeRecord1 		  			      |
					|       taskCode3		    |   TaskCodeRecord1 		  			      |
					|       taskCode4		    |   TaskCodeRecord1 		  			      |
					|       taskCode5		    |   TaskCodeRecord1 		  			      |
					
					|       newSourceId1		|   'Karate-Insert' + NewSourceId1 		      |
					|       newSourceId2		|   'Karate-Insert' + NewSourceId2 		      |
					|       newSourceId3		|   'Karate-Insert' + NewSourceId3 		      |
					|       newSourceId4		|   'Karate-Insert' + NewSourceId4 		      |
					|       newSourceId5		|   'Karate-Insert' + NewSourceId5 		      |
					
					|       reference1          |   NewReference1 + 'Karate-Insert1'          |
					|       reference2          |   NewReference1 + 'Karate-Insert2'          |
					|       reference3          |   NewReference1 + 'Karate-Insert3'          |
					|       reference4          |   NewReference1 + 'Karate-Insert4'          |
					|       reference5          |   NewReference1 + 'Karate-Insert5'          |
					
					|       description1		|		'No. 1 left-handed Hex bolt'		  |
					|       description2		|		'No. 1 left-handed Hex bolt'		  |
					|       description3		|		'No. 1 left-handed Hex bolt'		  |
					|       description4		|		'No. 1 left-handed Hex bolt'		  |
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
  	
  	* def sqlQuery1 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId1 + '\';'  
  	* def sqlQuery2 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference1 + 'Karate-Insert%\';'   
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery1, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery2, 5) == true
  	 	 	  	  	
  	
  	#Update to Service Check Point for Record 1
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord1 + ' AND taskCode:' + TaskCodeRecord1
    When method get
    Then status 200
    And match response $..parts[*].reference contains NewReference1 + 'Karate-Insert1'
    And match response $..parts[*].reference contains NewReference1 + 'Karate-Insert2'
    And match response $..parts[*].reference contains NewReference1 + 'Karate-Insert3'
    And match response $..parts[*].reference contains NewReference1 + 'Karate-Insert4'
    And match response $..parts[*].reference contains NewReference1 + 'Karate-Insert5'


    Scenario: Insert 5 Duplicate Part Consumption Parts and duplicate reference parts
   
   		* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplateComplex.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId1   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId2   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId3   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId4   			|   AssetTblAssetIdRecord1   	 			  |
				    | 		assetId5   			|   AssetTblAssetIdRecord1   	 			  |
				    
				    | 		country1  			|   CountryRecord1     		                  |
				    | 		country2  			|   CountryRecord1     		                  |
				    | 		country3  			|   CountryRecord1     		                  |
				    | 		country4  			|   CountryRecord1     		                  |
				    | 		country5  			|   CountryRecord1     		                  |
				    
					| 		sourceSystemCode1  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode2  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode3  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode4  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode5  	|   SourceSystemCodeRecord1                   |
					
					| 		serviceRequestCode1	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode2	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode3	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode4	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode5	|   ServiceRequestCodeRecord1 			      |
					
					|       taskCode1		    |   TaskCodeRecord1 		  			      |
					|       taskCode2		    |   TaskCodeRecord1 		  			      |
					|       taskCode3		    |   TaskCodeRecord1 		  			      |
					|       taskCode4		    |   TaskCodeRecord1 		  			      |
					|       taskCode5		    |   TaskCodeRecord1 		  			      |
					
					|       newSourceId1		|   'Karate-Insert' + NewSourceId1 		      |
					|       newSourceId2		|   'Karate-Insert' + NewSourceId1 		      |
					|       newSourceId3		|   'Karate-Insert' + NewSourceId1 		      |
					|       newSourceId4		|   'Karate-Insert' + NewSourceId1 		      |
					|       newSourceId5		|   'Karate-Insert' + NewSourceId1 		      |
					
					|       reference1          |   NewReference1 + 'Karate-Insert'          |
					|       reference2          |   NewReference1 + 'Karate-Insert'          |
					|       reference3          |   NewReference1 + 'Karate-Insert'          |
					|       reference4          |   NewReference1 + 'Karate-Insert'          |
					|       reference5          |   NewReference1 + 'Karate-Insert'          |
					
					|       description1		|		'No. 1 left-handed Hex bolt'		  |
					|       description2		|		'No. 1 left-handed Hex bolt'		  |
					|       description3		|		'No. 1 left-handed Hex bolt'		  |
					|       description4		|		'No. 1 left-handed Hex bolt'		  |
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
  	
  	* def sqlQuery1 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId1 + '\';'  
  	* def sqlQuery2 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference1 + 'Karate-Insert%\';'   
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery1, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery2, 1) == true
  	 	 	  	  	
  	
  	#Update to Service Check Point for Record 1
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord1 + ' AND taskCode:' + TaskCodeRecord1
    When method get
    Then status 200
    And match response $..parts[*].reference contains NewReference1 + 'Karate-Insert'



    Scenario: Insert 5 new Parts with various invalid/missing data for 3 out of 5 Parts and 1 Duplicate
   
   		* def ServiceRequestPartsTemplate = read('classpath:testsuite/testdata/ServiceRequestPartsTemplateComplex.json')
		* replace ServiceRequestPartsTemplate
					| 		token 				|   value   	 	  	 				      |
				    | 		assetId1   			|   'blahblah'				   	 			  |
				    | 		assetId2   			|   AssetTblAssetIdRecord2   	 			  |
				    | 		assetId3   			|   AssetTblAssetIdRecord3   	 			  |
				    | 		assetId4   			|   AssetTblAssetIdRecord4   	 			  |
				    | 		assetId5   			|   AssetTblAssetIdRecord5   	 			  |
				    
				    | 		country1  			|   CountryRecord1     		                  |
				    | 		country2  			|   'NK'		     		                  |
				    | 		country3  			|   CountryRecord3     		                  |
				    | 		country4  			|   CountryRecord4     		                  |
				    | 		country5  			|   CountryRecord5     		                  |
				    
					| 		sourceSystemCode1  	|   SourceSystemCodeRecord1                   |
					| 		sourceSystemCode2  	|   SourceSystemCodeRecord2                   |
					| 		sourceSystemCode3  	|   'wrong'				                      |
					| 		sourceSystemCode4  	|   SourceSystemCodeRecord4                   |
					| 		sourceSystemCode5  	|   SourceSystemCodeRecord5                   |
					
					| 		serviceRequestCode1	|   ServiceRequestCodeRecord1 			      |
					| 		serviceRequestCode2	|   ServiceRequestCodeRecord2 			      |
					| 		serviceRequestCode3	|   ServiceRequestCodeRecord3 			      |
					| 		serviceRequestCode4	|   ServiceRequestCodeRecord4 			      |
					| 		serviceRequestCode5	|   ServiceRequestCodeRecord5 			      |
					
					|       taskCode1		    |   TaskCodeRecord1 		  			      |
					|       taskCode2		    |   TaskCodeRecord2 		  			      |
					|       taskCode3		    |   TaskCodeRecord3 		  			      |
					|       taskCode4		    |   TaskCodeRecord4 		  			      |
					|       taskCode5		    |   TaskCodeRecord5 		  			      |
					
					|       newSourceId1		|   NewSourceId1 + 'Karate-Insert fail' 	  |
					|       newSourceId2		|   NewSourceId2 + 'Karate-Insert fail' 	  |
					|       newSourceId3		|   NewSourceId3 + 'Karate-Insert fail' 	  |
					|       newSourceId4		|   NewSourceId4 + 'Karate-Insert fail' 	  |
					|       newSourceId5		|   'Karate-Insert' + NewSourceId5 	  		  |
					
					|       reference1          |   NewReference1 + 'Karate-Insert fail'      |
					|       reference2          |   NewReference2 + 'Karate-Insert fail'      |
					|       reference3          |   NewReference3 + 'Karate-Insert fail'      |
					|       reference4          |   NewReference4 + 'Karate-Insert fail'      |
					|       reference5          |   'Karate-Insert' + NewReference5 	      |
					
					|       description1		|		'No. 1 left-handed Hex bolt'		  |
					|       description2		|		'No. 1 left-handed Hex bolt'		  |
					|       description3		|		'No. 1 left-handed Hex bolt'		  |
					|       description4		|		'No. 1 left-handed Hex bolt'		  |
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
  	* assert JavaMethods.checkMongoCollection('Parts', loadUID, 'REJECTED') == true	
  	
  	* def sqlQuery1 = 'SELECT * FROM PartTypeConsumption WHERE PartConsumptionSourceSystemId LIKE \'%' + NewSourceId5 + '\';'  
  	* def sqlQuery2 = 'SELECT * FROM PartType WHERE reference LIKE \'%' + NewReference5 + '\';'   	  	
  	
  	* assert JavaMethods.executeSQLQuery(sqlQuery1, 1) == true
  	* assert JavaMethods.executeSQLQuery(sqlQuery2, 1) == true
  	 	 	  	  	
  	
  	#Update to Service Check Point for Record 1
    Given path 'serviceRequests', 'tasks'
    * header Authorization = 'Bearer ' + Token
    And param view = 'full'
    And param q = 'serviceRequestCode:' + ServiceRequestCodeRecord5 + ' AND taskCode:' + TaskCodeRecord5
    When method get
    Then status 200
    And match response $..parts[*].reference contains 'Karate-Insert' + NewReference5 



  		Scenario: Insert two valid (first-last records), fail two records in between by trying to Update Parts within the same existing part
   
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



  
  	
  	