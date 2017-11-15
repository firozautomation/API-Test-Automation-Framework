#Objective: Automate All Service Request Service Methods 
#Audience: All aspired Automated Test Engineers
#Complete documentation on the Karate DSL Framework is found in Github via https://github.com/intuit/karate
#Author(s): APM Automated Test Team

Feature: Service Request Service POST Method Verification 

    Background:

    #DO NOT MODIFY UNLESS YOUR BRAVE AND YOU KNOW WHAT YOUR DOING*******************************************************
    * def JavaMethods = Java.type('reusable.ResuableMethods')
    * def setup = callonce read('classpath:reusable/Generate-Token.feature')
    * def Token = setup.token
    * def env = setup.Environment
    * def ch = setup.Channel
    * assert JavaMethods.socks5BypassConfig() == true
    * call JavaMethods.connectToMongo(env,ch)
    
    
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
    
     	#Stuff from Java
	    * def NewServiceRequestCode = JavaMethods.generateRandomNumber()
	    * def NewTaskCode = JavaMethods.generateRandomNumber()
   	    * def NewTaskCode = JavaMethods.generateRandomNumber()
   	    * def NewReference = JavaMethods.generateRandomNumber()
	    * def NewSourceId = JavaMethods.generateRandomNumber()	   
	   	* def NewTimesheet = JavaMethods.generateRandomNumber()
	    
   Scenario: Create a Full Payload
   
   * text sqlQuery = 
	  	"""
	  	SELECT * FROM ServiceRequest 
	  	WHERE serviceRequestCode = 'some value';
	  	
	  	"""
  	* print sqlQuery
 
    #Scenario: Test SOLR
  
    #Given url 'http://ic-sol-ver-02.cloud.ds.gehc.net:8983/solr/service-request02us/select?indent=on&q=*:*&wt=json'
  	#When method get
  	#Then status 200
  	
  	
  	#* assert JavaMethods.executeSQLQuery('SELECT * FROM PartType WHERE reference like \'%zzzz%\';', 18) == true
  	
  	